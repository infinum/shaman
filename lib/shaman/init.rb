module Shaman
  module Init
    def self.init(options)
      config = {
        release_path: options.file || ask('Release path:'),
        environment_token: options.token || ask('Environment token:'),
        deployer_email: options.user || ask('Labs deployer email:')
      }
      File.open(PROJECT_CONFIG_PATH, 'w') { |f| f.write(YAML.dump(config)) }
      say_ok '.shaman.yml created'
    end
  end
end
