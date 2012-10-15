class Git::Semaphore::App

  attr_accessor :env_auth_token
  attr_accessor :env_project_token

  def initialize config = ENV
    self.env_auth_token = config['SEMAPHORE_AUTH_TOKEN']
    self.env_project_token = config['SEMAPHORE_PROJECT_TOKEN']
  end

end
