require 'uri'
require 'json'
require 'openssl'
require 'net/http'
require 'fileutils'

require 'grit'

module Git
  module Semaphore

    def self.home_dir
      @home_dir ||= begin
        ENV['HOME'] || File.expand_path("~#{Etc.getlogin}")
      end
    end

    def self.cache_dir
      @cache_dir ||= begin
        File.join(self.home_dir, '.git', 'semaphore').tap do |cache_dir|
          FileUtils.mkdir_p(cache_dir)
        end
      end
    end

    def self.cache_dir_for identifier
      File.join(self.cache_dir, identifier).tap do |cache_dir|
        FileUtils.mkdir_p(cache_dir)
      end
    end

    def self.empty_cache_dir
      FileUtils.rm_r Dir.glob(File.join(self.cache_dir, '*'))
    end

    def self.from_json_cache path
      if File.exists? path
        JSON.parse(File.read(path))
      else
        yield.tap do |content|
          File.open(path, 'w') { |file| file.write content.to_json }
        end
      end
    end

    def self.git_repo
      @git_repo ||= begin
        Grit::Repo.new(Dir.pwd)
      rescue Grit::InvalidGitRepositoryError
        nil
      end
    end

    def self.env_auth_token
      @env_auth_token ||= ENV['SEMAPHORE_AUTH_TOKEN']
    end

    def self.git_auth_token
      git_repo && git_repo.config['semaphore.authtoken']
    end

    def self.auth_token
      git_auth_token || env_auth_token
    end

  end
end

require 'git/semaphore/version'
require 'git/semaphore/banner'
require 'git/semaphore/copyright'

require 'git/semaphore/api'
require 'git/semaphore/api_cache'
require 'git/semaphore/api_enrich'

require 'git/semaphore/project'
