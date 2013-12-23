module CustomMatchers
  extend RSpec::Matchers::DSL

  matcher :have_error_message do |message|
    match do |page|
      page.should have_selector 'div.alert.alert-error', text: message
    end
  end

  matcher :have_success_message do |message|
    match do |page|
      page.should have_selector 'div.alert.alert-success', text: message
    end
  end

  matcher :have_full_title_with do |title|
    match do |page|
      page.should have_selector 'title', text: full_title(title)
    end
  end
end
