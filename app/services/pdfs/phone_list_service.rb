# frozen_string_literal: true

require 'prawn'

module Pdfs
  class PhoneListService
    include Prawn::View
    include Pdfs::PrawnHelper

    TABLE_HEADER = [
      I18n.t('activerecord.attributes.civil_servant.address'),
      I18n.t('activerecord.attributes.civil_servant.phone'),
      I18n.t('activerecord.attributes.user.email')
    ].freeze

    def initialize(service_specifications, beginning, ending)
      update_font_families

      header(beginning.to_date, ending.to_date)
      content_table(service_specifications)
    end

    def document
      @document ||= Prawn::Document.new(page_size: 'A4', page_layout: :landscape)
    end

    private

    def header(beginning, ending)
      text I18n.t('pdfs.phone_list.header', date: I18n.l(Time.zone.today)), align: :right

      text(
        I18n.t(
          'pdfs.phone_list.title',
          beginning: I18n.l(beginning),
          ending: I18n.l(ending)
        ),
        align: :left,
        style: :bold,
        size: 15
      )
    end

    def content_table(service_specifications)
      service_specifications.each do |name, services|
        pre_table(name)

        font_size 10
        table(table_data(services),
              cell_style: { borders: %i[] },
              width: bounds.width,
              header: true,
              column_widths: [471.89, 120, 178]) do
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
        civil_servant_data service.civil_servant
      end
    end

    def civil_servant_data(civil_servant)
      [
        civil_servant.address.full_compose(', '),
        civil_servant.phone,
        civil_servant.user.email
      ]
    end
  end
end
