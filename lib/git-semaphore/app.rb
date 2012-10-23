
class Git::Semaphore::App

  attr_accessor :git_auth_token
  attr_accessor :git_project_token

  attr_accessor :env_auth_token
  attr_accessor :env_project_token

  def initialize working_dir, config = ENV

    @git_repo = Grit::Repo.new(working_dir)

    self.git_auth_token = @git_repo.config['semaphore.authtoken']
    self.git_project_token = @git_repo.config['semaphore.projecttoken']

    self.env_auth_token = config['SEMAPHORE_AUTH_TOKEN']
    self.env_project_token = config['SEMAPHORE_PROJECT_TOKEN']

  end

  def auth_token
    git_auth_token || env_auth_token
  end

  def project_token
    git_project_token || env_project_token
  end

  def working_dir
    @git_repo.working_dir
  end

  def project_name
    File.basename(@git_repo.working_dir)
  end

  def branch_name
    @git_repo.head.name
  end

  def projects
    uri = Git::Semaphore::Api.projects_uri(auth_token)
    Git::Semaphore::Api.get_response(uri).body
  end

end
