
class Git::Semaphore::App

  attr_accessor :git_auth_token
  attr_accessor :git_project_token

  attr_accessor :env_auth_token
  attr_accessor :env_project_token

  def initialize pwd, config = ENV

    @working_dir = pwd

    if (@git_repo = (Grit::Repo.new(@working_dir) rescue nil))
      self.git_auth_token = @git_repo.config['semaphore.authtoken']
      self.git_project_token = @git_repo.config['semaphore.projecttoken']
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

  def working_dir
    @working_dir
  end

  def project_name
    File.basename(@working_dir)
  end

  def branch_name
    @git_repo.head.name
  end

end
