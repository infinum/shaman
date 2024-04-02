require 'commander'

module Shaman
  class CLI
    include Commander::Methods

    def run
      program :name, 'shaman'
      program :version, Shaman::VERSION
      program :description, 'Shaman CLI for labs'
      program :help_formatter, :compact

      init
      deploy

      run!
    end

    def init # rubocop:disable Metrics/MethodLength
      command :init do |c|
        c.syntax = 'shaman init'
        c.description = 'Initialize your project. EXAMPLE: shaman init -s abamobi'
        c.option '-s', '--search SEARCH', String, 'Filter projects by a search term'
        c.option '-f', '--favorites', 'Show only favorites'
        c.option '-p', '--platform PLATFORM', 'Choose platform'
        c.option '-i', '--project_id PROJECT', 'Choose project id'
        c.action do |_args, options|
          Shaman::Init.check!
          Shaman::Init.init(options)
        end
      end
    end

    def deploy # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      command :deploy do |c|
        c.syntax = 'shaman deploy [environment]'
        c.description = 'Deploy a release to specified environment'
        c.option '-m', '--message MESSAGE', String, 'Changelog message'
        c.option '-f', '--file FILE', String, 'Release path'
        c.option '-t', '--token TOKEN', String, 'Use different user token'
        c.option '-c', '--config FILE', String, 'Use different config file'
        c.option '-g', '--git', 'Use git for message (overrides any manual settings!)'
        c.option '-C', '--commit COMMIT', String, 'Which commit to use instead of HEAD'
        c.option '-M', '--minimum_version', 'Set release as minimum version'
        c.option '-n', '--release_name RELEASE_NAME', String, 'Release name (ZIP platform only)'
        c.option '-x', '--env_token ENV_TOKEN', String, 'Environment token'
        c.action do |args, options|
          Shaman::Deploy.new(args, options).deploy
        rescue StandardError => e
          say_error e.message
          exit(-1)
        end
      end
    end
  end
end
