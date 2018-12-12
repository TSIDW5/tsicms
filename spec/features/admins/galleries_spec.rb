require 'rails_helper'

RSpec.describe 'Galleries', type: :feature do
  let(:admin) { create(:admin) }
  let(:gallery) { create(:gallery) }
  let(:resource_name) { Picture.model_name.human }

  before(:each) do
    login_as(admin, scope: :admin)
  end

  describe '#create' do
    before(:each) do
      visit new_admins_picture_path(gallery.context)
    end

    context 'with valid fields' do
      it 'upload picture' do
        picture_total = gallery.pictures.count

        pictures = [FileSpecHelper.image.path, FileSpecHelper.image.path]
        attach_file 'gallery_pictures', pictures
        submit_form

        expect(page).to have_current_path(admins_galleries_path(gallery.context))

        expect(page).to have_selector('div.alert.alert-success',
                                      text: I18n.t('flash.actions.create.f',
                                                   resource_name: resource_name))

        expect(gallery.pictures.count).to be == picture_total + 2
      end
    end

    context 'with invalid fields' do
      it 'show errors' do
        attach_file 'gallery_pictures', FileSpecHelper.pdf.path
        submit_form

        expect(page).to have_selector('div.alert.alert-danger',
                                      text: I18n.t('flash.actions.errors'))
        i18nmsg = 'errors.messages.extension_whitelist_error'
        text = I18n.t(i18nmsg, extension: '"pdf"', allowed_types: 'jpg, jpeg, gif, png')
        expect_page_have_in('div.gallery_pictures', text)
      end
    end
  end

  describe '#update' do
    let(:picture) { gallery.pictures.first }

    before(:each) do
      visit edit_admins_picture_path(gallery.context, picture.id)
    end

    context 'with fields filled' do
      it 'with correct values' do
        expect(page).to have_css("img[src*='#{picture.image}']")
      end
    end

    context 'with valid fields' do
      it 'update picture' do
        attributes = attributes_for(:picture)

        fill_in 'picture_label', with: attributes[:label]
        attach_file 'picture_image', FileSpecHelper.image.path
        submit_form

        expect(page).to have_current_path(admins_galleries_path(gallery.context))

        expect(page).to have_selector('div.alert.alert-success',
                                      text: I18n.t('flash.actions.update.f',
                                                   resource_name: resource_name))

        within("#gallery-#{gallery.context}") do
          expect(page).not_to have_css("img[src*='#{picture.image.url}']")
        end
      end
    end

    context 'with invalid fields' do
      it 'show errors' do
        fill_in 'picture_label', with: ''
        attach_file 'picture_image', FileSpecHelper.pdf.path
        submit_form

        expect(page).to have_selector('div.alert.alert-danger',
                                      text: I18n.t('flash.actions.errors'))

        expect_page_have_in('div.picture_image', I18n.t('errors.messages.extension_whitelist_error',
                                                        extension: '"pdf"',
                                                        allowed_types: 'jpg, jpeg, gif, png'))
      end
    end
  end

  describe '#index' do
    it 'has the correct content' do
      visit admins_galleries_path(gallery.context)

      expect(page).to have_css("#gallery-#{gallery.context}")

      gallery.pictures.each do |p|
        expect(page).to have_link(href: edit_admins_picture_path(gallery.context, p))
        expect_page_have_destroy_link(admins_picture_path(gallery.context, p))
      end
    end
  end

  describe '#destroy' do
    it 'gallery picture' do
      visit admins_galleries_path(gallery.context)

      picture = gallery.pictures.first

      click_on_destroy_link(admins_picture_path(gallery.context, picture))

      text = I18n.t('flash.actions.destroy.f', resource_name: resource_name)
      expect(page).to have_flash(:success, text: text)

      within("#gallery-#{gallery.context}") do
        expect(page).not_to have_css("img[src*='#{picture.image.url}']")
      end
    end
  end
end
