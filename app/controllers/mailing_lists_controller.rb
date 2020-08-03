# frozen_string_literal: true

class MailingListsController < ApplicationController
  authorize_resource

  def create
    @mailing_list = MailingList.new(mailing_list_params)

    if @mailing_list.save
      flash[:mailing_list_success] = I18n.t('mailing_list.successful_creation')
      redirect_to root_path(anchor: 'mailing-list')
    else
      flash[:mailing_list_error] = I18n.t('mailing_list.erroneous_creation')
      render 'home/index'
    end
  end

  private

  def mailing_list_params
    params.require(:mailing_list).permit(:email, :name, :organization, :telephone)
  end
end
