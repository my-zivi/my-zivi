# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SysAdmin::BlogEntriesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/sys_admin/blog_entries').to route_to('sys_admin/blog_entries#index')
    end

    it 'routes to #new' do
      expect(get: '/sys_admin/blog_entries/new').to route_to('sys_admin/blog_entries#new')
    end

    it 'routes to #show' do
      expect(get: '/sys_admin/blog_entries/1').to route_to('sys_admin/blog_entries#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/sys_admin/blog_entries/1/edit').to route_to('sys_admin/blog_entries#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/sys_admin/blog_entries').to route_to('sys_admin/blog_entries#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/sys_admin/blog_entries/1').to route_to('sys_admin/blog_entries#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/sys_admin/blog_entries/1').to route_to('sys_admin/blog_entries#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/sys_admin/blog_entries/1').to route_to('sys_admin/blog_entries#destroy', id: '1')
    end
  end
end
