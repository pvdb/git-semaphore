module Git
  module Semaphore
    class API

      def self.projects
        get_json projects_uri
      end

      def self.branches(project_hash_id)
        get_json branches_uri(project_hash_id)
      end

      def self.status(project_hash_id, branch_id)
        get_json status_uri(project_hash_id, branch_id)
      end

      def self.history(project_hash_id, branch_id)
        get_json history_uri(project_hash_id, branch_id)
      end

      def self.information(project_hash_id, branch_id, build_number)
        get_json information_uri(project_hash_id, branch_id, build_number)
      end

      def self.log(project_hash_id, branch_id, build_number)
        get_json log_uri(project_hash_id, branch_id, build_number)
      end

      def self.rebuild(project_hash_id, branch_id)
        get_json last_revision_uri(project_hash_id, branch_id), :post
      end

      #
      # private helper functions
      #

      def self.get_json(uri)
        @client ||= SemaphoreCI::API::V1.new(Git::Semaphore.auth_token)
        @client.get(uri)
      end

      def self.projects_uri
        # https://semaphoreci.com/docs/projects-api.html
        # GET /api/v1/projects
        File.join('/projects')
      end

      private_class_method :projects_uri

      def self.branches_uri(project_hash_id)
        # https://semaphoreci.com/docs/branches-and-builds-api.html#project_branches
        # GET /api/v1/projects/:hash_id/branches
        File.join('/projects', project_hash_id, 'branches')
      end

      private_class_method :branches_uri

      def self.status_uri(project_hash_id, branch_id)
        # https://semaphoreci.com/docs/branches-and-builds-api.html#branch_status
        # GET /api/v1/projects/:hash_id/:id/status
        File.join('/projects', project_hash_id, branch_id, 'status')
      end

      private_class_method :status_uri

      def self.history_uri(project_hash_id, branch_id)
        # https://semaphoreci.com/docs/branches-and-builds-api.html#branch_history
        # GET /api/v1/projects/:hash_id/:id
        File.join('/projects', project_hash_id, branch_id)
      end

      private_class_method :history_uri

      def self.information_uri(project_hash_id, branch_id, build_number)
        # https://semaphoreci.com/docs/branches-and-builds-api.html#build_information
        # GET /api/v1/projects/:hash_id/:id/builds/:number
        File.join('/projects', project_hash_id, branch_id, 'builds', build_number)
      end

      private_class_method :information_uri

      def self.log_uri(project_hash_id, branch_id, build_number)
        # https://semaphoreci.com/docs/branches-and-builds-api.html#build_log
        # GET /api/v1/projects/:hash_id/:id/builds/:number/log
        File.join('/projects', project_hash_id, branch_id, 'builds', build_number, 'log')
      end

      private_class_method :log_uri

      def self.last_revision_uri(project_hash_id, branch_id)
        # https://semaphoreci.com/docs/branches-and-builds-api.html#rebuild
        # POST /api/v1/projects/:project_hash_id/:branch_id/build
        File.join('/projects', project_hash_id, branch_id, 'build')
      end

      private_class_method :last_revision_uri

    end
  end
end
