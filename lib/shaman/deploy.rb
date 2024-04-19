require 'yaml'

module Shaman
  class Deploy
    include Helpers

    DEFAULT_ENVIRONMENT = 'default'.freeze
    DEFAULT_EDITOR = 'vi'.freeze
    DEFAULT_MESSAGE = ''.freeze
    DEFAULT_RELEASE_NAME = ''.freeze
    GIT_DEFAULT_DIRECTORY = '.'.freeze
    GIT_HEAD = 'HEAD'.freeze

    def initialize(args, options)
      @environment = args.first || DEFAULT_ENVIRONMENT
      @options = options
      verify_options
    end

    def deploy
      prompt.ok "Connecting to #{LABS_URL}/api/v1/releases"
      response = HTTP.post("#{LABS_URL}/api/v1/releases", form: deploy_options)
      response.code == 200 ? prompt.ok(response.body.to_s) : error!(response.body.to_s)
    end

    private

    attr_reader :environment, :options

    def deploy_options
      @deploy_options ||= {
        environment_token: options.env_token || config[:token],
        release: HTTP::FormData::File.new(options.file || config[:release_path]),
        message: message || DEFAULT_MESSAGE,
        token: options.token || ENV['SHAMAN_TOKEN'],
        minimum_version: options.minimum_version || false,
        name: options.release_name || DEFAULT_RELEASE_NAME
      }
    end

    def verify_options
      deploy_options.each do |key, value|
        raise "Please specify #{key}" if value.nil?
      end
    end

    def config
      @config ||= load_config
    end

    def gcommit
      @gcommit ||= Git.open(GIT_DEFAULT_DIRECTORY).gcommit(options.commit || GIT_HEAD)
    end

    def message
      return gcommit.message if options.git

      options.message || ask_editor(nil, ENV.fetch('EDITOR', DEFAULT_EDITOR))
    end

    def load_config
      YAML.load_file(config_file).fetch(environment)
    rescue KeyError => e
      error!("Envrionment #{environment} doesn't exist in #{config_file}")
    end

    def config_file
      options.config || PROJECT_CONFIG_PATH
    end
  end
end
