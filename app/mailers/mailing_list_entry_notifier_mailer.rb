# frozen_string_literal: true

class MailingListEntryNotifierMailer < ApplicationMailer
  TO = 'joshua.devadas@myzivi.ch'
  CC = %w[lukas.bischof@myzivi.ch philipp.fehr@myzivi.ch].freeze
  FROM = "MyZivi Mailing-List Notifier <#{ENV['MAIL_SENDER']}>"

  def notify
    @mailing_list = MailingList.find(params[:mailing_list_id])

    mail to: TO, cc: CC, from: FROM
  end
end
