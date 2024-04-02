require 'http'
require 'git'
require 'tty-prompt'
require 'shaman/helpers'
require 'shaman/cli'
require 'shaman/init'
require 'shaman/deploy'
require 'shaman/tryout_apps'
require 'shaman/tryout_apps/client'
require 'shaman/tryout_apps/resource'
require 'shaman/tryout_apps/resource/project'
require 'shaman/tryout_apps/resource/release'
require 'shaman/version'

module Shaman
  PROJECT_CONFIG_PATH = '.shaman.yml'.freeze

  class << self
    def tryout_apps_client
      @tryout_apps_client ||= Shaman::TryoutApps::Client.new(tryout_apps_base_uri)
    end

    def tryout_apps_base_uri
      ENV.fetch('SERVER_URL', tryout_apps_env_base_uri)
    end

    attr_writer :prompt

    def prompt
      @prompt ||= TTY::Prompt.new
    end

    private

    def tryout_apps_env_base_uri
      case ENV.fetch('SHAMAN_ENV', nil)
      when 'development' then Shaman::TryoutApps::DEVELOPMENT_BASE_URI
      when 'staging' then Shaman::TryoutApps::STAGING_BASE_URI
      else Shaman::TryoutApps::PRODUCTION_BASE_URI end
    end
  end
end
