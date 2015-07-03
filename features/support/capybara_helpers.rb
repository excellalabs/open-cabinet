def wait_for_ajax
  Timeout.timeout(Capybara.default_wait_time) do
    loop until finished_all_ajax_requests?
  end
end

def finished_all_ajax_requests?
  page.evaluate_script('jQuery.active').zero?
end

def sauce_click_wrapper(node)
  if Capybara.current_driver == :sauce
    node.click
  else
    node.trigger('click')
  end
end

def sauce_focus_wrapper(element_id)
  if Capybara.current_driver == :sauce
    find(element_id)
    script = %{ $("#{element_id}").focus() }
    page.execute_script(script)
  else
    find(element_id).trigger(:focus)
  end
end
