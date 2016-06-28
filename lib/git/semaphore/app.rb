class Git::Semaphore::App

  attr_writer :project_name
  attr_writer :branch_name
  attr_writer :commit_sha
  attr_writer :build_number

  attr_reader :branch_url

  def initialize auth_token, git_repo, config = ENV
    @auth_token = auth_token
    @git_repo   = git_repo

    self.project_name = config['SEMAPHORE_PROJECT_NAME']
    self.branch_name  = config['SEMAPHORE_BRANCH_NAME']
    self.commit_sha   = config['SEMAPHORE_COMMIT_SHA']
    self.build_number = config['SEMAPHORE_BUILD_NUMBER']
  end

  def to_json
    {
      semaphore_auth_token:   @auth_token,
      semaphore_project_name: self.project_name,
      semaphore_branch_name:  self.branch_name,
      semaphore_commit_sha:   self.commit_sha,
      semaphore_build_number: self.build_number,
    }.to_json
  end

  def project_name
    return @project_name unless @project_name.nil?
    File.basename @git_repo.git.work_tree if @git_repo
  end

  def branch_name
    return @branch_name unless @branch_name.nil?
    @git_repo.head.name if @git_repo
  end

  def commit_sha
    return @commit_sha unless @commit_sha.nil?
    @git_repo.head.commit.id if @git_repo
  end

  def build_number
    return @build_number unless @build_number.nil?
    history['builds'].first['build_number'].to_s
  end

  def projects
    Git::Semaphore::API::Cache.projects(@auth_token)
  end

  def branches
    Git::Semaphore::API::Cache.branches(project_hash_id, @auth_token)
  end

  def status
    Git::Semaphore::API::Cache.status(project_hash_id, branch_id, @auth_token)
  end

  def history
    Git::Semaphore::API::Cache.history(project_hash_id, branch_id, @auth_token)
  end

  def information
    Git::Semaphore::API::Cache.information(project_hash_id, branch_id, build_number, @auth_token,)
  end

  def log
    Git::Semaphore::API::Cache.log(project_hash_id, branch_id, build_number, @auth_token,)
  end

  def rebuild
    Git::Semaphore::API.rebuild(project_hash_id, branch_id, @auth_token)
  end

  def branch_url
    branch_hash = project_hash['branches'].find { |hash|
      hash['branch_name'] == branch_name
    }
    branch_hash['branch_url']
  end

  private

  def project_hash_for project_name
    projects.find { |project_hash|
      project_hash['name'] == project_name
    }
  end

  def project_hash
    project_hash_for(project_name)
  end

  def project_hash_id_for project_name
    project_hash_for(project_name)['hash_id']
  end

  def project_hash_id
    project_hash_id_for(project_name)
  end

  def branch_hash_for branch_name
    branches.find { |branch_hash|
      branch_hash['name'] == branch_name
    }
  end

  def branch_hash
    branch_hash_for(branch_name)
  end

  def branch_id_for branch_name
    branch_hash_for(branch_name)['id'].to_s
  end

  def branch_id
    branch_id_for(branch_name)
  end

  def build_status_for commit_sha
    history['builds'].find { |build_status|
      build_status['commit']['id'] == commit_sha
    }
  end

  def build_status
    build_status_for(commit_sha)
  end

end
