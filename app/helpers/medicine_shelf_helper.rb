module MedicineShelfHelper
  MEDICINES_IN_ROW = 3
  NUM_IMAGES = 7
  MIN_ROWS = 3
  def show_shelves(cabinet)
    result = ''
    cabinet.medicines.each_with_index do |medicine, i|
      result += shelf_start_html if new_shelf?(i)
      interaction = interaction_class_name(medicine, cabinet.primary_medicine)
      result += medicine_html(medicine, interaction)
      result += shelf_end_html if end_shelf?(cabinet.medicines, i)
    end
    result += add_empty_shelves(cabinet.medicines)
    result.html_safe
  end

  private

  def add_empty_shelves(medicines)
    result = ''
    num_rows = (medicines.length / MEDICINES_IN_ROW)
    num_rows += 1 if (medicines.length % MEDICINES_IN_ROW) > 0
    while num_rows < MIN_ROWS
      result += empty_shelf
      num_rows += 1
    end
    result
  end

  def class_name(str)
    str.gsub(/[\s.*]/, '-')
  end

  def empty_shelf
    (shelf_start_html + '<div class="empty-shelf">&nbsp;</div>' + shelf_end_html).html_safe
  end

  def  new_shelf?(index)
    index % MEDICINES_IN_ROW == 0
  end

  def end_shelf?(medicines, index)
    (index % MEDICINES_IN_ROW == (MEDICINES_IN_ROW - 1)) || (medicines.length - 1 == index)
  end

  def interaction_class_name(curr_medicine, primary_medicine)
    return 'active' if curr_medicine.name == primary_medicine.try(:name)
    return 'interact' if curr_medicine.interacts_with(primary_medicine)
    'disabled'
  end

  def medicine_key(medicine)
    medicine.name.to_sym
  end

  # rubocop:disable Metrics/MethodLength
  def medicine_html(medicine, interaction_class_name)
    <<-eos
    <div class='pill-container #{interaction_class_name} clickable-pill-container' pill-name-text='#{medicine.name}'
         data-type='pill-bottle'>
      <i class="fa fa-times pill-delete" data-set-id="#{medicine.id}"></i>
      <div class='pill-wrapper'>
        <div class='pill-bottle'>#{pill_image(medicine.name)}</div>
        #{ hidden_field_tag medicine.set_id }
        <div class='pill-name'>
          <div class='pill-name-text'>#{medicine.name}</div>
          <div class='pill-badge num-pill-interactions #{medicine.interaction? ? 'tooltip' : 'black'}'
               title='#{medicine.interaction_names.join('<br>')}' >
            #{medicine.interaction_count} <span class='visible-mobile'>interactions</span>
          </div>
        </div>
      </div>
      <div class="pill-next visible-mobile">
        <i class="fa fa-arrow-right"></i>
      </div>
    </div>
    eos
  end

  # rubocop:enable Metrics/MethodLength
  def pill_interaction_image(medicine_name, is_primary_medicine_row)
    options = { class: 'tooltip', title: medicine_name }
    options[:class] = 'active tooltip' if is_primary_medicine_row
    pill_image(medicine_name, options)
  end

  def pill_image(medicine_name, options = {})
    image_num = (medicine_name.length.abs % NUM_IMAGES) + 1
    image_tag("pills-0#{image_num}.png", options)
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
        <div class='border-overlay hidden-mobile'>&nbsp;</div>
      </div>
    eos
  end
end
