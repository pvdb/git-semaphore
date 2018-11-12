module Git
  module Semaphore
    class API

      def self.projects(auth_token)
        get_json projects_uri(auth_token)
      end

      def self.branches(project_hash_id, auth_token)
        get_json branches_uri(project_hash_id, auth_token)
      end

      def self.status(project_hash_id, branch_id, auth_token)
        get_json status_uri(project_hash_id, branch_id, auth_token)
      end

      def self.history(project_hash_id, branch_id, auth_token)
        get_paginated_response(history_uri(project_hash_id, branch_id, auth_token)) do |previous_page, next_page|
          previous_page['builds'] += next_page['builds']
        end
      end

      def self.information(project_hash_id, branch_id, build_number, auth_token)
        get_json information_uri(project_hash_id, branch_id, build_number, auth_token)
      end

      def self.log(project_hash_id, branch_id, build_number, auth_token)
        get_json log_uri(project_hash_id, branch_id, build_number, auth_token)
      end

      def self.rebuild(project_hash_id, branch_id, auth_token)
        get_json last_revision_uri(project_hash_id, branch_id, auth_token), :post
      end

      # private helper functions

      def self.projects_uri(auth_token)
        # https://semaphoreci.com/docs/projects-api.html
        # GET /api/v1/projects
        request_uri(auth_token, path: File.join('projects'))
      end

      private_class_method :projects_uri

      def self.branches_uri(project_hash_id, auth_token)
        # https://semaphoreci.com/docs/branches-and-builds-api.html#project_branches
        # GET /api/v1/projects/:hash_id/branches
        request_uri(auth_token, path: File.join('projects', project_hash_id, 'branches'))
      end

      private_class_method :branches_uri

      def self.status_uri(project_hash_id, branch_id, auth_token)
        # https://semaphoreci.com/docs/branches-and-builds-api.html#branch_status
        # GET /api/v1/projects/:hash_id/:id/status
        request_uri(auth_token, path: File.join('projects', project_hash_id, branch_id, 'status'))
      end

      private_class_method :status_uri

      def self.history_uri(project_hash_id, branch_id, auth_token, page = 1)
        # https://semaphoreci.com/docs/branches-and-builds-api.html#branch_history
        # GET /api/v1/projects/:hash_id/:id
        request_uri(auth_token, path: File.join('projects', project_hash_id, branch_id), page: page)
      end

      private_class_method :history_uri

      def self.information_uri(project_hash_id, branch_id, build_number, auth_token)
        # https://semaphoreci.com/docs/branches-and-builds-api.html#build_information
        # GET /api/v1/projects/:hash_id/:id/builds/:number
        request_uri(auth_token, path: File.join('projects', project_hash_id, branch_id, 'builds', build_number))
      end

      private_class_method :information_uri

      def self.log_uri(project_hash_id, branch_id, build_number, auth_token)
        # https://semaphoreci.com/docs/branches-and-builds-api.html#build_log
        # GET /api/v1/projects/:hash_id/:id/builds/:number/log
        request_uri(auth_token, path: File.join('projects', project_hash_id, branch_id, 'builds', build_number, 'log'))
      end

      private_class_method :log_uri

      def self.last_revision_uri(project_hash_id, branch_id, auth_token)
        # https://semaphoreci.com/docs/branches-and-builds-api.html#rebuild
        # POST /api/v1/projects/:project_hash_id/:branch_id/build
        request_uri(auth_token, path: File.join('projects', project_hash_id, branch_id, 'build'))
      end

      private_class_method :last_revision_uri

      # more private helper functions

      def self.get_response(uri, action = :get)
        response = ::Net::HTTP.start(uri.host, uri.port, use_ssl: (uri.scheme == 'https'), verify_mode: ::OpenSSL::SSL::VERIFY_NONE) do |net_http|
          case action
          when :get
            net_http.get uri.request_uri
          when :post
            net_http.post uri.request_uri, uri.query
          else
            raise 'Unsupported action'
          end
        end

        def response.json_body
          raise 'JSON response expected' \
            unless self['content-type'].match?(%r{application/json})
          JSON.parse(body)
        end

        response
      end

      private_class_method :get_response

      def self.get_paginated_response(uri, action = :get)
        response = get_response(uri, action)
        body = response.json_body
        loop do
          pagination_header = response['Pagination']
          break unless pagination_header
          pagination = JSON.parse(pagination_header)
          break if pagination['last_page']
          uri.query = uri.query.sub(/page=(\d+)/, "page=#{pagination['next_page']}")
          response = get_response(uri, action)
          yield(body, response.json_body)
        end
        body
      end

      private_class_method :get_paginated_response

      def self.get_json(uri, action = :get)
        get_response(uri, action).json_body
      end

      private_class_method :get_json

      # https://semaphoreci.com/docs/
      SEMAPHORE_API_HOST = 'semaphoreci.com'.freeze
      SEMAPHORE_API_URI = '/api/v1/'.freeze

      def self.request_uri(auth_token, options = {})
        page = options.delete(:page) # API pagination
        options[:host] ||= SEMAPHORE_API_HOST
        options[:path].prepend SEMAPHORE_API_URI
        options[:query] = "auth_token=#{auth_token}"
        options[:query] << "&page=#{page}" if page
        URI::HTTPS.build(options)
      end

      private_class_method :request_uri

    end
  end
end
