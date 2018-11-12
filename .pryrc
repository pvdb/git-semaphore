# this loads all of "git-semaphore"
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git/semaphore'

# utility function to set pry context
# to an instance of <Rugged::Repository>
def repository
  pry Git::Semaphore.git_repo
end

# utility function to set pry context
# to an instance of <Git::Semaphore::Project>
def project
  pry Git::Semaphore::Project.from_repo(Git::Semaphore.git_repo)
end
