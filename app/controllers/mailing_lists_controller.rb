# frozen_string_literal: true

class MailingListsController < ApplicationController
  authorize_resource

  def create
    if MailingList.create(mailing_list_params)
      flash[:success] = 'Blubby'
    else
      flash[:error] = 'Blubbs'
    end

    redirect_to root_path
  end

  private

  def mailing_list_params
    params.require(:mailing_list).permit(:email)
  end
end
