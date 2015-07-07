class CabinetPage
  include Capybara::DSL, Rails.application.routes.url_helpers

  def visit_home_page
    visit(cabinet_medicine_path)
  end

  def type_search_characters(characters)
    find('#search_input')
    fill_in('search_input', with: characters)
    sauce_focus_wrapper('#search_input')
  end

  def autocomplete_text
    # autocomplete is invisible but present
    find('.tt-highlight', visible: false).text
  end

  def select_autocomplete_text(text)
    find('.tt-suggestion', text: text, visible: false)
    script = %{ $(".tt-suggestion:contains('#{text}')").mouseenter().click() }
    page.execute_script(script)
  end

  def press_add_button
    sauce_click_wrapper(page.find('#add_medicine'))
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
