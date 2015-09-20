module Shaman
  module Init
    def self.init(options)
      config = {
        release_path: options.file || ask('Release path:'),
        environment_token: options.token || ask('Environment token:'),
        user: options.user || ask('Labs user email:')
      }
      File.open(PROJECT_CONFIG_PATH, 'w') { |f| f.write(YAML.dump(config)) }
      say 'shaman.yml created'
    end
  end
end
