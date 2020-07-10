# frozen_string_literal: true

require 'prawn'

module Pdfs
  class PhoneListService
    include Prawn::View
    include Pdfs::PrawnHelper

    TABLE_HEADER = [
      I18n.t('activerecord.attributes.civil_servant.first_name'),
      I18n.t('activerecord.attributes.civil_servant.last_name'),
      I18n.t('activerecord.attributes.address.street'),
      I18n.t('activerecord.attributes.address.zip_with_city'),
      I18n.t('activerecord.attributes.civil_servant.phone'),
      I18n.t('activerecord.attributes.user.email')
    ].freeze

    def initialize(service_specifications, dates)
      @beginning = dates.beginning
      @ending = dates.ending
      @service_specifications = service_specifications

      update_font_families

      header
      content_table
    end

    def document
      @document ||= Prawn::Document.new(page_size: 'A4', page_layout: :landscape)
    end

    private

    def header
      text I18n.t('pdfs.phone_list.header', date: I18n.l(Time.zone.today)), align: :right

      text(
        I18n.t(
          'pdfs.phone_list.title',
          beginning: I18n.l(@beginning),
          ending: I18n.l(@ending)
        ),
        align: :left,
        style: :bold,
        size: 15
      )
    end

    def content_table
      @service_specifications.each do |name, services|
        pre_table(name)

        font_size 10
        table(table_data(services),
              cell_style: { borders: %i[] },
              width: bounds.width,
              header: true,
              column_widths: [98, 98, 179.89, 118, 98, 178]) do
          row(0).font_style = :bold
        end
      end
    end

    def pre_table(name)
      move_down 25

      text(
        name,
        align: :left,
        style: :bold,
        size: 11
      )
    end

    def table_data(services)
      [TABLE_HEADER].push(*table_content(services))
    end

    def table_content(services)
      services.map do |service|
        service_data service
      end
    end

    def service_data(service)
      [
        service.civil_servant.first_name,
        service.civil_servant.last_name,
        service.civil_servant.address.street,
        service.civil_servant.address.zip_with_city,
        service.civil_servant.phone,
        service.civil_servant.user.email
      ]
    end
  end
end
