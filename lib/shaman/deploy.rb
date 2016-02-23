module Shaman
  class Deploy
    attr_reader :options

    def initialize(options)
      @options = options
      verify_options
    end

    def deploy
      say_ok "Connecting to #{LABS_URL}/api/v1/releases"
      say_ok "Sending #{deploy_options.to_yaml}"
      response = HTTP.post("#{LABS_URL}/api/v1/releases", form: deploy_options)
      response.code == 200 ? say_ok(response.body.to_s) : say_error(response.body.to_s)
    end

    private

    def deploy_options
      @deploy_options ||= {
        environment_token: options.token || config[:environment_token],
        release: HTTP::FormData::File.new(options.file || config[:release_path]),
        message: message || '',
        deployer: deployer
      }
    end

    def verify_options
      deploy_options.each do |key, value|
        fail "Please specify #{key}" if value.nil?
      end
    end

    def config
      @config ||= YAML.load_file(options.config || PROJECT_CONFIG_PATH)
    end

    def gcommit
      @gcommit ||= Git.open('.').gcommit(options.commit || 'HEAD')
    end

    def message
      options.git ? gcommit.message : options.message || ask_editor(nil, 'vi')
    end

    def deployer
      options.git ? gcommit.committer.email : options.deployer || config[:deployer_email]
    end
  end
end
