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

    def phone_numbers
      if respond_to? :phone
        phone
      else
        phones.map { |p| p[:value] }
      end
    end

    def email_addresses
      if respond_to? :email
        email
      else
        emails.map { |e| e[:value] }
      end
    end
  end
end
