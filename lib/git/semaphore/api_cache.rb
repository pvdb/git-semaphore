module Git
  module Semaphore
    class API
      class Cache

        def self.projects auth_token
          @projects ||= Git::Semaphore.from_json_cache(projects_cache) do
            API::Enrich.projects auth_token
          end
        end

        def self.branches project_hash_id, auth_token
          @branches ||= Git::Semaphore.from_json_cache(branches_cache(project_hash_id)) do
            API.branches project_hash_id, auth_token
          end
        end

        def self.status project_hash_id, branch_id, auth_token
          @status ||= Git::Semaphore.from_json_cache(status_cache(project_hash_id, branch_id)) do
            API.status project_hash_id, branch_id, auth_token
          end
        end

        def self.history project_hash_id, branch_id, auth_token
          @history ||= Git::Semaphore.from_json_cache(history_cache(project_hash_id, branch_id)) do
            API::Enrich.history project_hash_id, branch_id, auth_token
          end
        end

        def self.information project_hash_id, branch_id, build_number, auth_token
          @information ||= Git::Semaphore.from_json_cache(information_cache(project_hash_id, branch_id, build_number)) do
            API.information project_hash_id, branch_id, build_number, auth_token
          end
        end

        def self.log project_hash_id, branch_id, build_number, auth_token
          @log ||= Git::Semaphore.from_json_cache(log_cache(project_hash_id, branch_id, build_number)) do
            API.log project_hash_id, branch_id, build_number, auth_token
          end
        end

        # private helper functions

        def self.projects_cache
          File.join(Git::Semaphore.cache_dir, 'projects.json')
        end

        private_class_method :projects_cache

        def self.branches_cache project_hash_id
          File.join(Git::Semaphore.cache_dir_for(project_hash_id), 'branches.json')
        end

        private_class_method :branches_cache

        def self.status_cache project_hash_id, branch_id
          File.join(Git::Semaphore.cache_dir_for(project_hash_id), "#{branch_id}_status.json")
        end

        private_class_method :status_cache

        def self.history_cache project_hash_id, branch_id
          File.join(Git::Semaphore.cache_dir_for(project_hash_id), "#{branch_id}_history.json")
        end

        private_class_method :history_cache

        def self.information_cache project_hash_id, branch_id, build_number
          File.join(Git::Semaphore.cache_dir_for(project_hash_id), "#{branch_id}_#{build_number}_information.json")
        end

        private_class_method :information_cache

        def self.log_cache project_hash_id, branch_id, build_number
          File.join(Git::Semaphore.cache_dir_for(project_hash_id), "#{branch_id}_#{build_number}_log.json")
        end

        private_class_method :log_cache

      end
    end
  end
end
