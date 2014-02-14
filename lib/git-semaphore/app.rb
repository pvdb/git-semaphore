require 'json'

class Git::Semaphore::App

  attr_accessor :env_auth_token
  attr_accessor :env_project_token

  attr_accessor :working_dir
  attr_writer   :branch_name
  attr_accessor :commit
  attr_writer   :project_name

  def initialize working_dir, config = ENV
    self.working_dir = working_dir

    self.project_name = config['PROJECT']
    self.branch_name = config['BRANCH']
    self.commit = config['COMMIT']

    self.env_auth_token = config['SEMAPHORE_AUTH_TOKEN']
    self.env_project_token = config['SEMAPHORE_PROJECT_TOKEN']
  end

  def git_auth_token
    git_repo.config['semaphore.authtoken']
  end

  def git_project_token
    git_repo.config['semaphore.projecttoken']
  end

  def git_repo
    @git_repo ||= Grit::Repo.new(working_dir)
  end

  def validate
    '' != branch_name.to_s.gsub(/\s+/, '')
  rescue
    false
  end

  def auth_token
    git_auth_token || env_auth_token
  end

  def project_token
    git_project_token || env_project_token
  end

  def project_name
    return @project_name unless @project_name.nil?
    File.basename working_dir
  end

  def branch_name
    return @branch_name unless @branch_name.nil?
    git_repo.head.name
  end

  def projects
    @projects ||= begin
      uri = Git::Semaphore::Api.projects_uri(auth_token)
      Git::Semaphore::Api.get_response(uri).body
    end
  end

  def branches
    @branches ||= begin
      uri = Git::Semaphore::Api.branches_uri(project_hash_id, auth_token)
      Git::Semaphore::Api.get_response(uri).body
    end
  end

  def status
    @status ||= begin
      uri = Git::Semaphore::Api.status_uri(project_hash_id, branch_id, auth_token)
      Git::Semaphore::Api.get_response(uri).body
    end
  end

  def commit_status
    uri = Git::Semaphore::Api.history_uri(project_hash_id, branch_id, auth_token)
    j = Git::Semaphore::Api.get_response(uri).body
    builds = JSON.parse(j)['builds']
    build = builds.detect { |b| b['commit']['id'] == commit }
  end

  private

  def project_hash_for project_name
    JSON::parse(projects).find { |project_hash|
      project_hash['name'] == project_name
    }
  end

  def project_hash_id_for project_name
    project_hash_for(project_name)['hash_id']
  end

  def project_hash_id
    project_hash_id_for(project_name)
  end

  def branch_hash_for branch_name
    JSON::parse(branches).find { |branch_hash|
      branch_hash['name'] == branch_name
    }
  end

  def branch_id_for branch_name
    branch_hash_for(branch_name)['id']
  end

  def branch_id
    branch_id_for(branch_name).to_s
  end

end
