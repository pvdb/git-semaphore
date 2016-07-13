class Git::Semaphore::Project

  def initialize git_repo, config = ENV
    @auth_token = Git::Semaphore.auth_token
    @git_repo   = git_repo

    if full_name = config['SEMAPHORE_PROJECT_NAME']
      @owner, @name = full_name.split('/')
    end

    @branch_name  = config['SEMAPHORE_BRANCH_NAME']
    @commit_sha   = config['SEMAPHORE_COMMIT_SHA']
    @build_number = config['SEMAPHORE_BUILD_NUMBER']
  end

  def settings
    {
      auth_token:   @auth_token,
      project_name: full_name,
      branch_name:  branch_name,
      commit_sha:   commit_sha,
      build_number: build_number,
    }
  end

  def internals
    settings.merge({
      project: {
        owner:      owner,
        name:       name,
        full_name:  full_name,
        hash_id:    project_hash_id,
      },
      branch: {
        name:       branch_name,
        id:         branch_id,
      },
      build: {
        number:     build_number,
        result:     build_result,
      },
    })
  end

  def owner
    return @owner unless @owner.nil?
    File.basename(File.dirname(@git_repo.git.work_tree)) if @git_repo
  end

  def name
    return @name unless @name.nil?
    File.basename(@git_repo.git.work_tree) if @git_repo
  end

  def full_name
    [owner, name].join('/')
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

  def project_hash_for owner, name
    projects.find { |project_hash|
      project_hash['owner'] == owner && project_hash['name'] == name
    }
  end

  def project_hash
    project_hash_for(owner, name)
  end

  def project_hash_id_for owner, name
    project_hash_for(owner, name)['hash_id']
  end

  def project_hash_id
    project_hash_id_for(owner, name)
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

  def build_for build_number # commit_sha
    history['builds'].find { |build|
      # FIXME the commit_sha possibly doesn't exist
      # on GitHub - and hence Semaphore - just yet!
      # build['commit']['id'] == commit_sha
      build['build_number'].to_s == build_number
    }
  end

  def build_result
    # build_for(commit_sha)['result']
    build_for(build_number)['result']
  end

end
