class CabinetPage
  include Capybara::DSL, Rails.application.routes.url_helpers

  def visit_home_page
    visit(cabinet_medicine_path)
  end

  def type_search_characters(characters)
    fill_in('search_input', with: characters)
    find('#search_input').trigger(:focus)
  end

  def autocomplete_text
    # autocomplete is invisible but present
    find('.tt-highlight', visible: false).text
  end

  def select_autocomplete_text(text)
    script = %{ $('.tt-suggestion:contains("#{text}")').mouseenter().click() }
    page.execute_script(script)
  end

  def press_add_button
    page.find('#add_medicine').trigger('click')
  end

  def active_pill_container
    '.pill-container.active'
  end

  def interact_pill_container
    '.pill-container.interact'
  end

  def disabled_pill_container
    '.pill-container.disabled'
  end

  def pill_name_text
    '.pill-name-text'
  end

  def add_medicine(medicine)
    type_search_characters(medicine)
    select_autocomplete_text(autocomplete_text)
    press_add_button
    wait_for_ajax
    assert_selector '.pill-name', text: medicine
    assert_selector '.primary-name', text: medicine
  end

  def med_description
    page.find_by_id('indications-and-usage')
  end

  def med_dosage
    page.find_by_id('dosage-and-administration')
  end

  def med_warnings
    page.find_by_id('warnings')
  end

  def create_session_cabinet_with_medicines(medicines)
    cabinet = Cabinet.create(medicines: medicines)
    page.set_rack_session(cabinet_id: cabinet.id)
  end

  def select_medicine(medicine_name)
    find("div[pill-name-text='#{medicine_name}']").click
  end

  def interaction_tiles
    tiles = ''
    within('#interactions-list') do
      tiles = all('li')
    end
    tiles
  end
end
