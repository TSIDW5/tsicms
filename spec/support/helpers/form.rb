module Helpers
  module Form
    def submit_form(submit = '//input[type=submit]')
      find(submit).click
    end

    def have_contains(field, content)
      within(field) do
        expect(page).to have_content(content)
      end
    end

    def not_have_contains(field, content)
      within(field) do
        expect(page).not_to have_content(content)
      end
    end

    def not_have_equals(field, content)
      within(field) do
        expect(page).not_to eq(content)
      end
    end

    def destroy_model(url, resource_name, message)
      destroy_link = "a[href='#{url}'][data-method='delete']"
      find(destroy_link).click

      expect(page).to have_selector('div.alert.alert-success',
                                    text: I18n.t(message,
                                                 resource_name: resource_name))
    end
  end
end
