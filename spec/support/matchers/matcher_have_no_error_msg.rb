RSpec::Matchers.define :have_no_error_message do
          match do |page|  #technically this is a capaybara sessions object
            page.has_no_selector?('div.alert.alert-error')
          end
end
