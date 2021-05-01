# frozen_string_literal: true

module SysAdmins
  class BlogEntriesController < ApplicationController
    layout 'sys_admins/application'

    before_action :set_blog_entry, only: %i[show edit update destroy]

    def index
      @blog_entries = BlogEntry.all
    end

    def show; end

    def new
      @blog_entry = BlogEntry.new
    end

    def edit; end

    def create
      @blog_entry = BlogEntry.new(blog_entry_params)

      if @blog_entry.save
        redirect_to sys_admins_blog_entry_path(@blog_entry),
                    notice: I18n.t('sys_admins.blog_entries.successful_creation')
      else
        render :new
      end
    end

    def update
      if @blog_entry.update(blog_entry_params)
        redirect_to sys_admins_blog_entry_path(@blog_entry),
                    notice: I18n.t('sys_admins.blog_entries.successful_update')
      else
        render :edit
      end
    end

    def destroy
      @blog_entry.destroy
      redirect_to sys_admins_blog_entries_path, notice: 'Blog entry was successfully destroyed.'
    end

    private

    def set_blog_entry
      @blog_entry = BlogEntry.find(params[:id])
    end

    def blog_entry_params
      params.require(:blog_entry).permit(:title, :content, :author, :published, :description)
    end
  end
end
