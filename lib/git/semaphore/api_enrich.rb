module Git
  module Semaphore
    class API
      class Enrich

        def self.projects
          API.projects.tap do |results|
            results.each do |project|
              # full repository name on github.com: 'pvdb/git-semaphore'
              project['full_name']  = [project['owner'], project['name']].join('/')
              # https://semaphoreci.com/pvdb/git-semaphore -> https://github.com/pvdb/git-semaphore
              project['github_url'] = project['html_url'].sub(/semaphoreci\.com/, 'github.com')
            end
          end
        end

        def self.history(project_hash_id, branch_id)
          API.history(project_hash_id, branch_id).tap do |history|
            history['builds'].each do |build|
              enrich(build)
            end
          end
        end

        def self.status(project_hash_id, branch_id)
          API.status(project_hash_id, branch_id).tap do |status|
            enrich(status)
          end
        end

        def self.enrich(build)
          # build['result'] = "passed", "failed", "stopped" or "pending"
          return unless (started_at  = build['started_at'])
          return unless (finished_at = build['finished_at'])
          started_at  = Time.parse(started_at)
          finished_at = Time.parse(finished_at)
          build['date'] = {
            started_at:  started_at.to_date,
            finished_at: finished_at.to_date,
          }
          build['iso8601'] = {
            started_at:  started_at.utc.iso8601,
            finished_at: finished_at.utc.iso8601,
          }
          build['epoch'] = {
            started_at:  started_at.to_f,
            finished_at: finished_at.to_f,
          }
          build['duration'] = {
            seconds: (finished_at - started_at).to_i,
            minutes: format('%0.2f', (finished_at - started_at) / 60).to_f,
          }
        end

        private_class_method :enrich

      end
    end
  end
end
