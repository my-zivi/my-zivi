# frozen_string_literal: true

class RegionalCenter
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :name, :address, :identifier

  validates :name, :address, presence: true
  attribute :name, :string

  class << self
    Rails.configuration.x.regional_centers.each do |identifier, config|
      downcased_identifier = identifier.to_s.downcase

      define_method ActiveSupport::Inflector.transliterate(downcased_identifier, locale: :'de-CH') do
        RegionalCenter.new(config.merge(
                             address: StaticAddress.new(config[:address]),
                             identifier: downcased_identifier
                           ))
      end
    end

    def find(identifier)
      id = identifier.to_s.downcase
      return nil unless Rails.configuration.x.regional_centers.key? id.to_sym

      public_send(ActiveSupport::Inflector.transliterate(id))
    end

    def all
      Rails.configuration.x.regional_centers.keys.map do |identifier|
        find(identifier)
      end
    end
  end
end
