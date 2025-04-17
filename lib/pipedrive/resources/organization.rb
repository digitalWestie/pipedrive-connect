# frozen_string_literal: true

module Pipedrive
  class Organization < Resource
    include Fields
    include Merge

    has_many :activities, class_name: "Activity"
    has_many :deals, class_name: "Deal"
    has_many :persons, class_name: "Person"

    def self.supports_v2_api?
      true
    end
  end
end
