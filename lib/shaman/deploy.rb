# frozen_string_literal: true

require 'yaml'

module Shaman
  class Deploy
    include Helpers
    include Commander::Methods

    DEFAULT_ENVIRONMENT = 'default'
    DEFAULT_EDITOR = 'vi'
    DEFAULT_MESSAGE = ''
    DEFAULT_RELEASE_NAME = ''
    GIT_DEFAULT_DIRECTORY = '.'
    GIT_HEAD = 'HEAD'

    def initialize(args, options)
      @environment = args.first || DEFAULT_ENVIRONMENT
      @options = options
      verify_release!
    end

    def deploy
      prompt.ok "Connecting to #{Shaman.tryout_apps_base_uri}/api/v1/releases"

      response = Shaman.tryout_apps_client.create_release(release)

      if response.success?
        prompt.ok(response.data)
      else
        error!("Failed to create a release: #{response.data}")
      end
    end

    private

    attr_reader :environment
    attr_reader :options

    def release
      @release ||=
        Shaman::TryoutApps::Resource::Release::CreateInput.new({ file: release_file,
                                                                 environment_token: environment_token,
                                                                 message: message,
                                                                 token: token,
                                                                 minimum_version: minimum_version,
                                                                 name: name })
    end

    def environment_token
      options.env_token || config[:token]
    end

    def release_file
      options.file || config[:release_path]
    end

    def token
      options.token || ENV.fetch('SHAMAN_TOKEN', nil)
    end

    def minimum_version
      options.minimum_version || false
    end

    def name
      options.release_name || DEFAULT_RELEASE_NAME
    end

    def verify_release!
      release.form.each do |attribute, value|
        error!("Release attribute not specified: #{attribute}") if value.nil?
      end
    end

    def config
      @config ||= load_config
    end

    def gcommit
      @gcommit ||= Git.open(GIT_DEFAULT_DIRECTORY).gcommit(options.commit || GIT_HEAD)
    end

    def message
      (options.git && gcommit.message) ||
        options.message ||
        ask_editor(nil, ENV.fetch('EDITOR', DEFAULT_EDITOR)) ||
        DEFAULT_MESSAGE
    end

    def load_config
      YAML.load_file(config_file).fetch(environment)
    rescue Errno::ENOENT => _e
      error!("Config file #{config_file} doesn't exist")
    rescue KeyError => _e
      error!("Envrionment #{environment} doesn't exist in #{config_file}")
    end

    def config_file
      @config_file ||= options.config || PROJECT_CONFIG_PATH
    end
  end
end
