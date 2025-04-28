# frozen_string_literal: true

module Pipedrive
  module APIOperations
    module Request
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def supports_v2_api?
          # default setting, override in resources as required
          false
        end

        def api_version_for(endpoint = nil)
          return :v1 unless supports_v2_api?
          return :v1 if endpoint&.end_with?("Fields")
          Pipedrive.api_version
        end

        def api_version_prefix
          # Version 1 endpoints don't use the '/api/' prefix
          return api_version if api_version == :v1

          "api/#{api_version}"
        end

        def api_base_url
          "#{BASE_URL}/#{api_version_prefix}"
        end

        def request(method, url, params = {})
          check_api_key!
          raise "Not supported method" \
            unless %i[get post put patch delete].include?(method)

          Util.debug "#{name} #{method.upcase} #{url}"

          version = api_version_for(url)

          response = api_client(version).send(method) do |req|
            req.url url
            req.params = { api_token: Pipedrive.api_key }
            if %i[post put patch].include?(method)
              req.body = params.to_json
            else
              req.params.merge!(params)
            end
          end

          Util.serialize_response(response)
        end

        def api_client
          @api_client = Faraday.new(
            url: api_base_url,
            headers: { "Content-Type": "application/json" }
          ) do |faraday|
            if Pipedrive.debug_http
              faraday.response :logger, Pipedrive.logger,
                               bodies:  Pipedrive.debug_http_body
            end

            faraday.adapter Pipedrive.faraday_adapter
          end
        end

        protected def check_api_key!
          return if Pipedrive.api_key

          raise AuthenticationError, "No API key provided. " \
                                     "Set your API key using 'Pipedrive.api_key = <API-KEY>'"
        end
      end

      protected def request(method, url, params = {})
        self.class.request(method, url, params)
      end
    end
  end
end
