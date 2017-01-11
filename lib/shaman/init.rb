module Shaman
  class Init
    include Shaman::Helpers
    extend Shaman::Helpers

    def self.check
      return unless ENV['SHAMAN_TOKEN'].nil?
      error! "SHAMAN_TOKEN not defined. Please find it at #{LABS_URL}/me"
    end

    def self.init(options)
      new(options).call
    end

    def initialize(options)
      @options = options
    end

    def call
      @platform = choose_platform if options.platform.nil?
      @project_id = choose_project_id if options.project_id.nil?
      write_config
      prompt.ok '.shaman.yml created'
      prompt.say(File.read(PROJECT_CONFIG_PATH), color: :cyan)
    end

    private

    attr_reader :options

    def choose_platform
      prompt.select('Choose platform:', [:android, :ios, :zip, :air, :web])
    end

    def choose_project_id
      prompt.enum_select('Choose project:') do |menu|
        menu.enum '.'
        projects.each do |project|
          menu.choice "#{project['name']} (#{project['id']})", project['id']
        end
      end
    end

    def write_config
      project = projects.detect { |p| p['id'] == project_id }
      error!('wrong project id') if project.nil?
      config = {}
      project['environments'].each do |environment|
        next unless environment['platform'] == platform.to_s
        release_path = prompt.ask("Release path for #{environment['name']}", default: 'path/to/release')
        config[environment['name']] = {
          release_path: release_path,
          token: environment['token']
        }
      end
      File.open(PROJECT_CONFIG_PATH, 'w') { |f| f.write(YAML.dump(config)) }
    end

    def projects
      return @projects if @projects
      response = HTTP.get(
        "#{LABS_URL}/api/v1/projects",
        params: {
          token: ENV['SHAMAN_TOKEN'], favorites: favorites, search: search, platform: platform
        }
      )
      @projects = JSON.parse(response.body)
    end

    def favorites
      options.favorites
    end

    def search
      options.search
    end

    def project_id
      @project_id || options.project_id.to_i
    end

    def platform
      @platform || options.platform
    end
  end
end
