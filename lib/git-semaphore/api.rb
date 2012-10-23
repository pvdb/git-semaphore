require 'uri'
require 'net/http'

module Git
  module Semaphore
    class Api

      # http://docs.semaphoreapp.com/api

      SEMAPHORE_API_HOST = 'semaphoreapp.com'
      SEMAPHORE_API_URI = '/api/v1'

      def self.projects_uri auth_token
        URI::HTTPS.build(
          :host => SEMAPHORE_API_HOST,
          :path => File.join(SEMAPHORE_API_URI, 'projects'),
          :query => "auth_token=#{auth_token}"
        )
      end

      def self.branches_uri project_hash_id, auth_token
        URI::HTTPS.build(
          :host => SEMAPHORE_API_HOST,
          :path => File.join(SEMAPHORE_API_URI, 'projects', project_hash_id, 'branches'),
          :query => "auth_token=#{auth_token}"
        )
      end

      def self.status_uri project_hash_id, branch_id, auth_token
        URI::HTTPS.build(
          :host => SEMAPHORE_API_HOST,
          :path => File.join(SEMAPHORE_API_URI, 'projects', project_hash_id, branch_id, 'status'),
          :query => "auth_token=#{auth_token}"
        )
      end

      # helper functions

      def self.get_response uri
        ::Net::HTTP.start(uri.host, uri.port, :use_ssl => (uri.scheme == 'https'), :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |net_http|
          net_http.get(uri.request_uri)
        end
      end

    end
  end
end