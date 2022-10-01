# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SysAdmins::BlogEntriesController, type: :request do
  let(:valid_attributes) { attributes_for(:blog_entry) }
  let(:invalid_attributes) { attributes_for(:blog_entry).merge(title: '') }
  let(:sys_admin) { create(:sys_admin) }

  before { sign_in sys_admin }

  describe '#index' do
    before do
      create(:blog_entry)
      get sys_admins_blog_entries_url
    end

    it 'renders a successful response' do
      expect(response).to be_successful
    end
  end

  describe '#show' do
    before { get sys_admins_blog_entry_path(create(:blog_entry)) }

    it 'renders a successful response' do
      expect(response).to be_successful
    end
  end

  describe '#new' do
    before { get new_sys_admins_blog_entry_path }

    it 'renders a successful response' do
      expect(response).to be_successful
    end
  end

  describe '#edit' do
    let(:blog_entry) { create(:blog_entry) }

    it 'render a successful response' do
      get edit_sys_admins_blog_entry_path(blog_entry)
      expect(response).to be_successful
    end
  end

  describe '#create' do
    let(:perform_request) { post sys_admins_blog_entries_path, params: { blog_entry: params } }
    let(:params) { valid_attributes }

    context 'with valid parameters' do
      let(:created_blog_entry) { BlogEntry.order(:created_at).last }

      it 'creates blog entry and redirects to the created blog entry' do
        expect { perform_request }.to change(BlogEntry, :count).by(1)
        expect(response).to redirect_to(sys_admins_blog_entry_path(created_blog_entry))
        expect(flash[:notice]).to eq I18n.t('sys_admins.blog_entries.successful_creation')
      end
    end

    context 'with invalid parameters' do
      let(:params) { invalid_attributes }

      it 'does not create blog entry and renders an error message' do
        expect { perform_request }.not_to change(BlogEntry, :count)
        expect(response).to be_successful
        expect(flash[:error]).to eq I18n.t('sys_admins.blog_entries.erroneous_creation')
      end
    end
  end

  describe '#update' do
    let(:perform_request) { patch sys_admins_blog_entry_path(blog_entry), params: { blog_entry: params } }
    let!(:blog_entry) { create(:blog_entry) }

    context 'with valid parameters' do
      let(:params) { { title: 'My new title' } }

      it 'redirects to the blog_entry' do
        expect { perform_request }.to(change { blog_entry.reload.title })
        expect(response).to redirect_to(sys_admins_blog_entry_path(blog_entry))
      end
    end

    context 'with invalid parameters' do
      let(:params) { invalid_attributes }

      it "renders a successful response (i.e. to display the 'edit' template)" do
        expect { perform_request }.not_to change(blog_entry, :reload)
        expect(response).to be_successful
        expect(response).to render_template 'sys_admins/blog_entries/edit'
        expect(flash[:error]).to eq I18n.t('sys_admins.blog_entries.erroneous_update')
      end
    end
  end

  describe 'destroy' do
    let!(:blog_entry) { create(:blog_entry) }
    let(:perform_request) { delete sys_admins_blog_entry_path(blog_entry) }

    it 'deletes the blog entry and redirects to the sys_admin_blog_entries list' do
      expect { perform_request }.to change(BlogEntry, :count).by(-1)
      expect(response).to redirect_to(sys_admins_blog_entries_path)
      expect(flash[:notice]).to eq I18n.t('sys_admins.blog_entries.destroy.successful_destroy')
    end
  end
end
