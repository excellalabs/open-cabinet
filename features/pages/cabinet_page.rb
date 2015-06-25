class CabinetPage
  include Capybara::DSL, Rails.application.routes.url_helpers

  def visit_home_page
    visit(cabinet_path)
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
    click_button 'add_medicine'
  end
end
