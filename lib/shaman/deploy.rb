module Shaman
  class Deploy
    include Helpers

    def initialize(args, options)
      error!('Must specify environment') if args.count < 1
      @environment = args.first
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
      raise 'Wrong environment' if config.nil?
      @deploy_options ||= {
        environment_token: config[:token],
        release: HTTP::FormData::File.new(options.file || config[:release_path]),
        message: message || '',
        token: options.token || ENV['SHAMAN_TOKEN'],
        minimum_version: options.minimum_version || false,
        name: options.release_name || ''
      }
    end

    def verify_options
      deploy_options.each do |key, value|
        raise "Please specify #{key}" if value.nil?
      end
    end

    def config
      @config ||=
        YAML.load_file(options.config || PROJECT_CONFIG_PATH)[environment]
    end

    def gcommit
      @gcommit ||= Git.open('.').gcommit(options.commit || 'HEAD')
    end

    def message
      options.git ? gcommit.message : options.message || ask_editor(nil, 'vi')
    end
  end
end
