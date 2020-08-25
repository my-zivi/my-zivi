# frozen_string_literal: true

class MailingListEntryNotifierMailer < ApplicationMailer
  TO = 'joshua.dedevadas@gmail.com'
  CC = %w[me@luk4s.dev philipp@thefehr.me].freeze
  FROM = "MyZivi Mailing-List Notifier <#{ENV['MAIL_SENDER']}>"

  def notify
    @mailing_list = MailingList.find(params[:mailing_list_id])

    mail to: TO, cc: CC, from: FROM
  end
end
