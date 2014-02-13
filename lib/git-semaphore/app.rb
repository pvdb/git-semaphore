require 'json'

class Git::Semaphore::App

  attr_accessor :git_auth_token
  attr_accessor :git_project_token

  attr_accessor :env_auth_token
  attr_accessor :env_project_token

  attr_accessor :working_dir

  def initialize working_dir, config = ENV
    self.working_dir = working_dir

    self.git_auth_token = @git_repo.config['semaphore.authtoken']
    self.git_project_token = @git_repo.config['semaphore.projecttoken']

    self.env_auth_token = config['SEMAPHORE_AUTH_TOKEN']
    self.env_project_token = config['SEMAPHORE_PROJECT_TOKEN']

  end

  def git_repo
    @git_repo ||= Grit::Repo.new(working_dir)
  end

  def validate
    git_repo
  end

  def auth_token
    git_auth_token || env_auth_token
  end

  def project_token
    git_project_token || env_project_token
  end

  def project_name
    File.basename(working_dir)
  end

  def branch_name
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
