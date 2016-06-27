module Git
  module Semaphore
    class API
      class Enrich

        def self.projects auth_token
          API.projects(auth_token).tap do |results|
            results.each do |project|
              # full repository name on github.com: 'pvdb/git-semaphore'
              project['full_name']  = [project['owner'], project['name']].join('/')
              # https://semaphoreci.com/pvdb/git-semaphore -> https://github.com/pvdb/git-semaphore
              project['github_url'] = project['html_url'].sub(/semaphoreci\.com/, 'github.com')
            end
          end
        end

        def self.history project_hash_id, branch_id, auth_token
          API.history(project_hash_id, branch_id, auth_token).tap do |results|
            results['builds'].each do |build|
              # build['result'] = "passed", "failed", "stopped" or "pending"
              next unless started_at  = build['started_at']
              next unless finished_at = build['finished_at']
              started_at  = DateTime.parse(started_at).to_time
              finished_at = DateTime.parse(finished_at).to_time
              build['date'] = {
                :started_at  =>  started_at.to_date,
                :finished_at => finished_at.to_date,
              }
              build['duration'] = {
                :seconds => (finished_at - started_at).to_i,
                :minutes => "%0.2f" % ((finished_at - started_at) / 60),
              }
            end
          end
        end

      end
    end
  end
end
