require 'uri'
require 'net/http'

module Git
  module Semaphore
    class Api

      # http://docs.semaphoreapp.com/api

      SEMAPHORE_API_HOST = 'semaphoreapp.com'
      SEMAPHORE_API_URI = '/api/v1'

      def self.projects_uri auth_token
        build_request_uri(auth_token, :path => File.join(SEMAPHORE_API_URI, 'projects'))
      end

      def self.branches_uri project_hash_id, auth_token
        build_request_uri(auth_token, :path => File.join(SEMAPHORE_API_URI, 'projects', project_hash_id, 'branches'))
      end

      def self.status_uri project_hash_id, branch_id, auth_token
        build_request_uri(auth_token, :path => File.join(SEMAPHORE_API_URI, 'projects', project_hash_id, branch_id, 'status'))
      end

      def self.history_uri project_hash_id, branch_id, auth_token
        build_request_uri(auth_token, :path => File.join(SEMAPHORE_API_URI, 'projects', project_hash_id, branch_id))
      end

      def self.last_revision_uri project_hash_id, branch_id, auth_token
        build_request_uri(auth_token, :path => File.join(SEMAPHORE_API_URI, 'projects', project_hash_id, branch_id, 'build'))
      end

      # helper functions

      def self.get_response uri, action=:get
        ::Net::HTTP.start(uri.host, uri.port, :use_ssl => (uri.scheme == 'https'), :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |net_http|
          case action
          when :get
            net_http.get uri.request_uri
          when :post
            net_http.post uri.request_uri, uri.query
          else
            raise 'Unsupported action'
          end
        end
      end

      def self.build_request_uri auth_token, options={}
        URI::HTTPS.build(
          { :host  => SEMAPHORE_API_HOST,
            :query => "auth_token=#{auth_token}"
          }.merge(options)
        )
      end
      private_class_method(:build_request_uri)

    end
  end
end
