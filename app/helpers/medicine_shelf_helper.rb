module MedicineShelfHelper
  MEDICINES_IN_ROW = 3
  NUM_IMAGES = 7
  MIN_ROWS = 3
  def show_shelves(cabinet)
    result = ''
    cabinet.medicines.each_with_index do |medicine, i|
      result += shelf_start_html if new_shelf?(i)
      result += medicine_html(medicine)
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

  def empty_shelf
    (shelf_start_html + '<div class="empty-shelf">&nbsp;</div>' + shelf_end_html).html_safe
  end

  def  new_shelf?(index)
    index % MEDICINES_IN_ROW == 0
  end

  def end_shelf?(medicines, index)
    (index % MEDICINES_IN_ROW == (MEDICINES_IN_ROW - 1)) || (medicines.length - 1 == index)
  end

  # RP deleted -- data-module='delete-icon'
  def medicine_html(medicine)
    <<-eos
    <div class='pill-container' data-type='pill-bottle'>
      <span data-interactions=''></span>
      <i class="fa fa-times pill-delete" data-set-id="#{medicine.id}"></i>
      <div class='pill-wrapper'>
        <div class='pill-bottle'>#{pill_image(medicine)}</div>
        #{ hidden_field_tag medicine.set_id }
        <div class='pill-name'>#{medicine.name}</div>
      </div>
      <div class="pill-next visible-mobile"><i class="fa fa-arrow-right"></i></div>
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
        <div class='border-overlay hidden-mobile'>&nbsp;</div>
      </div>
    eos
  end
end
