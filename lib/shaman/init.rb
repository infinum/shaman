require 'yaml'

module Shaman
  class Init
    PLATFORMS = [:android, :ios, :zip, :air, :web].freeze

    include Shaman::Helpers
    extend Shaman::Helpers

    def self.check!
      return unless ENV['SHAMAN_TOKEN'].nil?

      error!("SHAMAN_TOKEN isn't defined. Find it at #{Shaman.tryout_apps_base_uri}/users/me")
    end

    def self.init(options)
      new(options).call
    end

    def initialize(options)
      @options = options
    end

    def call
      error!("Invalid project id: #{project_id}") if selected_project.nil?

      File.write(PROJECT_CONFIG_PATH, YAML.dump(config))
      prompt.ok '.shaman.yml created'
      prompt.say(File.read(PROJECT_CONFIG_PATH), color: :cyan)
    end

    private

    attr_reader :options

    def selected_project
      @selected_project = projects.find { |project| project.id == project_id }
    end

    def projects
      @projects ||= begin
        response = fetch_projects
        error!("Failed to load projects: #{response.data}") unless response.success?
        response.data
      end
    end

    def fetch_projects
      params = { token: ENV.fetch('SHAMAN_TOKEN', nil), platform: }
      params[:favorites] = options.favorites if options.favorites
      params[:search] = options.search if options.search

      Shaman.tryout_apps_client.list_projects(params)
    end

    def project_id
      @project_id ||= options.project_id&.to_i || choose_project_id
    end

    def choose_project_id
      prompt.enum_select('Choose project:') do |menu|
        menu.enum '.'
        projects.each do |project|
          menu.choice "#{project.name} (#{project.id})", project.id
        end
      end
    end

    def choose_platform
      prompt.select('Choose platform:', PLATFORMS)
    end

    def config
      selected_project
        .environments
        .select { |environment| environment.platform == platform }
        .reduce({}) do |memo, environment|
        release_path = prompt.ask("Release path for #{environment.name}", default: 'path/to/release')

        memo.merge(environment.name => { release_path:, token: environment.token })
      end
    end

    def platform
      @platform ||= options.platform || choose_platform.to_s
    end
  end
end
