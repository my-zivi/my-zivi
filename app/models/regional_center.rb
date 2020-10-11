# frozen_string_literal: true

class RegionalCenter
  include ActiveModel::Model

  validates :name, :address, presence: true

  attr_accessor :name, :address, :identifier

  class << self
    Rails.configuration.x.regional_centers.each do |identifier, config|
      downcased_identifier = identifier.downcase

      define_method ActiveSupport::Inflector.transliterate(downcased_identifier, locale: :'de-CH') do
        RegionalCenter.new(config.merge(
                             address: StaticAddress.new(config[:address]),
                             identifier: downcased_identifier
                           ))
      end
    end

    def find(identifier)
      id = identifier.downcase
      return nil unless Rails.configuration.x.regional_centers.key? id

      public_send(ActiveSupport::Inflector.transliterate(id))
    end
  end
end
