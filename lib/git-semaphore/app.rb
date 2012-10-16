class Git::Semaphore::App

  attr_accessor :git_auth_token
  attr_accessor :git_project_token

  attr_accessor :env_auth_token
  attr_accessor :env_project_token

  def initialize git_repo, config = ENV

    if git_repo
      self.git_auth_token = git_repo.config['semaphore.authtoken']
      self.git_project_token = git_repo.config['semaphore.projecttoken']
    end

    self.env_auth_token = config['SEMAPHORE_AUTH_TOKEN']
    self.env_project_token = config['SEMAPHORE_PROJECT_TOKEN']

  end

  def auth_token
    git_auth_token || env_auth_token
  end

  def project_token
    git_project_token || env_project_token
  end

end
