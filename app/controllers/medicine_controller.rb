class MedicineController < ApplicationController
  before_action :find_or_create_cabinet, except: [:search, :autocomplete]

  def autocomplete
    ary = []
    Rails.cache.fetch('autocomplete', expires_in: 6.hour) do
      SearchableMedicine.find_in_batches(batch_size: 5000) do |group|
        ary.push(*group)
      end
    end
    render json: ary.map(&:name)
  end

  def cabinet
    gon.meds = @cabinet.medicines
    gon.images = (1..MedicineShelfHelper::NUM_IMAGES).map { |num| ActionController::Base.helpers.asset_path("pills-0#{num}.png") }
  end

  def refresh_shelves
    render 'medicine/shared/_shelves', layout: false
  end

  def add_to_cabinet
    med = SearchableMedicine.find_by(name: medicine_params)
    @cabinet.add_to_cabinet(name: med.name, set_id: med.set_id)
    # render json: { name: med.name, set_id: med.set_id }, status: :ok
    render json: fake_data
  end

  def destroy
    render json: nil, status: :ok if @cabinet.medicines.find { |medicine| medicine.name == medicine_params }.destroy
  end

  def query_for_information
    render json: MedicineInformationService.fetch_information(params[:medicine_id], @cabinet)
  end

  private

  def fake_data
    {:primary=>"Warfarin Sodium",
 :interactions_text=>
  "ibuprofen 7. DRUG INTERACTIONS Consult labeling of all concurrently used drugs for complete information about interactions with warfarin sodium or increased risks for bleeding. (7) Inhibitors and inducers of CYP2C9, 1A2, or 3A4: May alter warfarin exposure. Monitor INR closely when any such drug is used with warfarin sodium. (7.1) Drugs that increase bleeding risk: Closely monitor patients receiving any such drug (e.g., other anticoagulants, antiplatelet agents, nonsteroidal anti-inflammatory drugs, serotonin reuptake inhibitors). (7.2) Antibiotics and antifungals: Closely monitor INR when initiating or stopping an antibiotic or antifungal course of therapy. (7.3) Botanical (herbal) products: Some may influence patient response to warfarin sodium necessitating close INR monitoring. (7.4) Drugs may interact with warfarin sodium through pharmacodynamic or pharmacokinetic mechanisms. Pharmacodynamic mechanisms for drug interactions ",
 :indications_and_usage=>
  "1. INDICATIONS AND USAGE Warfarin sodium tablets, USP are a vitamin K antagonist indicated for: Prophylaxis and treatment of venous thrombosis and its extension, pulmonary embolism (1) Prophylaxis and treatment of thromboembolic complications associated with atrial fibrillation and/or cardiac valve replacement (1) Reduction in the risk of death, recurrent myocardial infarction, and thromboembolic events such as stroke or systemic embolization after myocardial infarction (1) Limitation of Use Warfarin sodium tablets, USP have no direct effect on an established thrombus, nor does it reverse ischemic tissue damage. (1) Warfarin sodium tablets,USP are indicated for: Prophylaxis and treatment of venous",
 :dosage_and_administration=>
  "2. DOSAGE AND ADMINISTRATION Individualize dosing regimen for each patient, and adjust based on INR response. (2.1, 2.2) Knowledge of genotype can inform initial dose selection. (2.3) Monitoring: Obtain daily INR determinations upon initiation until stable in the therapeutic range. Obtain subsequent INR determinations every 1 to 4 weeks. (2.4) Review conversion instructions from other anticoagulants. (2.8) 2.1 Individualized Dosing The dosage and administration of warfarin sodium must be individualized for each patient according to the patient's INR response to the drug. Adjust the dose based on the patient's INR and the condition being treated. Consult the latest evidence-based clinical practice guidelines from the American College of Chest Physicians (ACCP) to assist in the determination of the duration and intensity of anticoagulation with warfarin sodium [see References (15)]. ",
 :warnings=>nil,
 :interactions=>{:Ibuprofen=>["ibuprofen", nil]}}
  end

  def medicine_params
    params.require(:medicine)
  end

  def find_or_create_cabinet
    return @cabinet = Cabinet.includes(:medicines).find_by_id(session[:cabinet_id]) if session[:cabinet_id]
    user = current_user
    if user && user.cabinet
      @cabinet = user.cabinet
    else
      @cabinet = Cabinet.create!(user: user)
    end
    session[:cabinet_id] = @cabinet.id
  end
end
