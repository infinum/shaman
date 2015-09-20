module Shaman
  class Deploy
    attr_reader :deploy_options

    def initialize(options)
      git
      config = YAML.load_file(options.config || PROJECT_CONFIG_PATH)
      @deploy_options = {
        environment_token: options.token || config[:environment_token],
        reloease_path: options.file || config[:release_path],
        message: options.message # || changelog
      }
      raise 'Please specify path to upload' if deploy_options[:release_path].nil?
    end

    def deploy
      # API.deploy(project_id, file_path, message, options[:o], options[:i], options[:h])
    end

    def git
      g = Git.open('.')
      binding.pry
    end
  end
end
