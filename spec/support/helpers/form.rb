module Helpers
  module Form
    def submit_form(submit = '//input[type=submit]')
      find(submit).click
    end

    def expect_page_have_in(field, content)
      within(field) do
        expect(page).to have_content(content)
      end
    end

    def expect_page_have_blank_messages(fields)
      fields.each(&method(:expect_page_have_blank_message))
    end

    def expect_page_have_blank_message(field)
      expect_page_have_in(field, I18n.t('errors.messages.blank'))
    end

    def expect_page_not_have_in(field, content)
      within(field) do
        expect(page).not_to have_content(content)
      end
    end

    def not_have_equals(field, content)
      within(field) do
        expect(page).not_to eq(content)
      end
    end

    def expect_page_have_destroy_link(url)
      destroy_link = "a[href='#{url}'][data-method='delete']"
      expect(page).to have_css(destroy_link)
    end

    def click_on_destroy_link(url)
      destroy_link = "a[href='#{url}'][data-method='delete']"
      find(destroy_link).click
    end
  end
end
