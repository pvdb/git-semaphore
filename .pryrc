# this loads all of "git semaphore"
load "exe/git-semaphore" unless Kernel.const_defined? 'Git::Semaphore'

# utility function to set pry context
# to an instance of <Git::Semaphore::Project>
def project() pry Git::Semaphore::Project.new(Git::Semaphore.git_repo, ENV) ; end
