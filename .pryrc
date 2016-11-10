$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'git/semaphore'

# utility function to set pry context
# to an instance of <Rugged::Repository>
def repository() pry Git::Semaphore.git_repo ; end

# utility function to set pry context
# to an instance of <Git::Semaphore::Project>
def project() pry Git::Semaphore::Project.from_repo(Git::Semaphore.git_repo) ; end
