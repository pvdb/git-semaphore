module Git
  module Semaphore
    class Project

      def self.env_overrides
        ENV.to_h.select { |key, _| key.start_with? 'SEMAPHORE_' }
      end

      def self.from_repo(git_repo)
        from_config({
          'SEMAPHORE_PROJECT_NAME' => git_repo.full_name,
          'SEMAPHORE_BRANCH_NAME'  => git_repo.head.name.split('/').last,
          'SEMAPHORE_COMMIT_SHA'   => git_repo.head.target.oid,
          'SEMAPHORE_BUILD_NUMBER' => nil
        }.merge(env_overrides))
      end

      def self.from_config(config)
        new(
          config['SEMAPHORE_PROJECT_NAME'],
          config['SEMAPHORE_BRANCH_NAME'],
          commit_sha:   config['SEMAPHORE_COMMIT_SHA'],
          build_number: config['SEMAPHORE_BUILD_NUMBER'],
        )
      end

      def initialize(full_name, branch_name = nil, options = {})
        @auth_token   = Git::Semaphore.auth_token
        @full_name    = full_name
        @owner, @name = full_name.split('/')
        @branch_name  = branch_name || 'master'
        @commit_sha   = options[:commit_sha]
        @build_number = options[:build_number]
      end

      def settings
        {
          auth_token:   @auth_token,
          project_name: @full_name,
          branch_name:  @branch_name,
          commit_sha:   @commit_sha,
          build_number: @build_number,
        }
      end

      def internals
        settings.merge(
          project: {
            owner:      @owner,
            name:       @name,
            full_name:  @full_name,
            hash_id:    project_hash_id,
            url:        project_url,
          },
          branch: {
            name:       @branch_name,
            id:         branch_id,
            url:        branch_url,
          },
          build: {
            number:     build_number,
            result:     build_result,
            url:        build_url,
          },
        )
      end

      #
      # build-related queries: default to latest one...
      #

      def build_number
        @build_number ||= history['builds'].first['build_number'].to_s
      end

      def build_result
        @build_result ||= history['builds'].first['result']
      end

      #
      # direct links to semaphore.ci
      #

      def project_url
        project_hash['html_url']
      end

      def branch_url
        branch_hash = project_hash['branches'].find { |hash|
          hash['branch_name'] == @branch_name
        }
        branch_hash['branch_url']
      end

      def build_url
        build_hash = history['builds'].find { |hash|
          hash['build_number'].to_s == @build_number
        }
        build_hash['build_url']
      end

      #
      # API related queries
      #

      def self.all
        Git::Semaphore::API::Cache.projects(Git::Semaphore.auth_token)
      end

      class << self
        alias_method :projects, :all
      end

      def branches
        Git::Semaphore::API::Cache.branches(project_hash_id, @auth_token)
      end

      def status
        Git::Semaphore::API::Cache.status(project_hash_id, branch_id, @auth_token)
      end

      def history
        Git::Semaphore::API::Cache.history(project_hash_id, branch_id, @auth_token)
      end

      def information
        Git::Semaphore::API::Cache.information(project_hash_id, branch_id, build_number, @auth_token)
      end

      def log
        Git::Semaphore::API::Cache.log(project_hash_id, branch_id, build_number, @auth_token)
      end

      def rebuild
        Git::Semaphore::API.rebuild(project_hash_id, branch_id, @auth_token)
      end

      def browse
        `open #{branch_url}`
        { url: branch_url }
      end

      private

      def project_hash_for(owner, name)
        self.class.projects.find { |project_hash|
          project_hash['owner'] == owner && project_hash['name'] == name
        }
      end

      def project_hash
        project_hash_for(@owner, @name)
      end

      def project_hash_id_for(owner, name)
        project_hash_for(owner, name)['hash_id']
      end

      def project_hash_id
        project_hash_id_for(@owner, @name)
      end

      def branch_hash_for(branch_name)
        branches.find { |branch_hash|
          branch_hash['name'] == branch_name
        }
      end

      def branch_hash
        branch_hash_for(@branch_name)
      end

      def branch_id_for(branch_name)
        branch_hash_for(branch_name)['id'].to_s
      end

      def branch_id
        branch_id_for(@branch_name)
      end

    end
  end
end
