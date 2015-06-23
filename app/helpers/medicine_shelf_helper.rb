module MedicineShelfHelper
  MEDICINES_IN_ROW = 3
  NUM_IMAGES = 7
  def show_shelves(cabinet)
    return empty_shelf.html_safe if !cabinet || cabinet.medicines.empty?
    result = ''
    cabinet.medicines.each_with_index do |medicine, i|
      result += shelf_start_html if new_shelf?(i)
      result += medicine_html(medicine)
      result += shelf_end_html if end_shelf?(cabinet.medicines, i)
    end
    result.html_safe
  end

  private

  def empty_shelf
    (shelf_start_html + shelf_end_html).html_safe
  end

  def  new_shelf?(index)
    index % MEDICINES_IN_ROW == 0
  end

  def end_shelf?(medicines, index)
    (index % MEDICINES_IN_ROW == (MEDICINES_IN_ROW - 1)) || (medicines.length - 1 == index)
  end

  def medicine_html(medicine)
    <<-eos
    <div class='pill-container disabled'>
      <i class="fa fa-times pill-delete" data-set-id="#{medicine.id}"></i>
      <div class='pill-wrapper'>
        <div class='pill-bottle'>#{pill_image(medicine)}</div>
        #{ hidden_field_tag medicine.set_id }
        <div class='pill-name'>#{medicine.name}</div>
      </div>
    </div>
    eos
  end

  def pill_image(medicine)
    image_num = (medicine.name.hash.abs % NUM_IMAGES) + 1
    image_tag("pills-0#{image_num}.png")
  end

  def shelf_start_html
    <<-eos
    <div class='shelf-wrapper'>
      <div class='shelf'>
    eos
  end

  def shelf_end_html
    <<-eos
        </div>
        <div class='border-overlay'>&nbsp;</div>
      </div>
    eos
  end
end
