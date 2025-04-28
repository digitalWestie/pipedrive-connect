# frozen_string_literal: true

module Pipedrive
  class Person < Resource
    include Fields
    include Merge

    has_many :deals, class_name: "Deal"
    has_many :activities, class_name: "Activity"

    def self.supports_v2_api?
      true
    end

    def organization_id
      # Handle both search and retrieve response formats
      if @data.has_key? :org_id
        @data.dig(:org_id)
      else
        @data.dig(:organization, :id)
      end
    end

    def phone_numbers
      if respond_to? :phone
        phone
      else
        phones.map { |p| p.is_a?(Hash) ? p[:value] : p }
      end
    end

    def email_addresses
      if respond_to? :email
        email
      else
        emails.map { |e| e.is_a?(Hash) ? e[:value] : e }
      end
    end
  end
end
