require 'uri'
require 'date'
require 'json'
require 'time'
require 'openssl'
require 'net/http'
require 'fileutils'

require 'faraday'
require 'nitlink'
require 'rugged'

require 'ext/faraday'
require 'ext/nitlink'

module Rugged
  class Repository
    def owner()     File.basename(File.dirname(workdir)); end
    def name()      File.basename(workdir);               end
    def full_name() "#{owner}/#{name}";                   end
  end
end

module Git
  module Semaphore
    class Error < StandardError; end

    def self.home_dir
      @home_dir ||= begin
        ENV['HOME'] || File.expand_path("~#{Etc.getlogin}")
      end
    end

    def self.cache_dir
      @cache_dir ||= begin
        File.join(home_dir, '.git', 'semaphore').tap do |cache_dir|
          FileUtils.mkdir_p(cache_dir)
        end
      end
    end

    def self.cache_dir_for(identifier)
      File.join(cache_dir, identifier).tap do |cache_dir|
        FileUtils.mkdir_p(cache_dir)
      end
    end

    def self.empty_cache_dir
      FileUtils.rm_r Dir.glob(File.join(cache_dir, '*'))
    end

    def self.from_json_cache(path, refresh = false)
      if !refresh && File.exist?(path)
        JSON.parse(File.read(path))
      else
        yield.tap do |content|
          File.open(path, 'w') { |file| file.write content.to_json }
        end
      end
    end

    def self.git_repo
      Rugged::Repository.new(Dir.pwd)
    rescue Rugged::RepositoryError
      nil
    end

    def self.env_auth_token
      @env_auth_token ||= ENV['SEMAPHORE_AUTH_TOKEN']
    end

    def self.global_auth_token
      Rugged::Config.global['semaphore.authtoken']
    end

    def self.git_auth_token
      git_repo&.config&.get('semaphore.authtoken')
    end

    def self.auth_token
      git_auth_token || global_auth_token || env_auth_token
    end

  end
end

require 'git/semaphore/version'

require 'semaphore_ci/api'

require 'git/semaphore/api'
require 'git/semaphore/api_cache'
require 'git/semaphore/api_enrich'

require 'git/semaphore/project'
