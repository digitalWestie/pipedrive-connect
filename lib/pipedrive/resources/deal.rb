# frozen_string_literal: true

module Pipedrive
  class Deal < Resource
    include Fields
    include Merge

    has_many :products, class_name: "Product"
    has_many :participants, class_name: "Participant"

    def self.supports_v2_api?
      true
    end

    def organization_id
      # Handle both search and retrieve response formats
      id = @data.fetch(:organization, {}).fetch(:id, nil)
      id = @data.fetch(:org_id, nil) if id.nil?
      id
    end

    def person_id
      # Handle both search and retrieve response formats
      id = @data.fetch(:person, {}).fetch(:id, nil)
      id = @data.fetch(:person_id, nil) if id.nil?
      id
    end
  end
end
