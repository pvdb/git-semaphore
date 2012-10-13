class Git::Semaphore::App

  attr_accessor :auth_token
  attr_accessor :project_token

  def initialize config = ENV
    self.auth_token = config['SEMAPHORE_AUTH_TOKEN']
    self.project_token = config['SEMAPHORE_PROJECT_TOKEN']
  end

end
