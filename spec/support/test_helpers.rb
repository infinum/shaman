# frozen_string_literal: true

require 'fileutils'
require 'yaml'

module Shaman
  module TestHelpers
    module Prompt
      def test_prompt
        Shaman.prompt = TTY::TestPrompt.new
      end
    end

    module Terminal
      def mock_terminal
        @term_input = StringIO.new
        @term_output = StringIO.new
        HighLine.default_instance = HighLine.new(term_input, term_output)
      end

      def term_input
        @term_input
      end

      def term_output
        @term_output
      end
    end

    module Command
      def run_command(command, options: [])
        mock_argv([command, *options])
        Shaman::CLI.new.run
      end

      def mock_argv(args)
        Commander::Runner.instance_variable_set :@instance, Commander::Runner.new(args)
      end

      def reply(*answers)
        answers.each { |answer| Shaman.prompt.input << answer << "\r" }

        Shaman.prompt.input.rewind
      end

      def within_test_dir(&block)
        dir = File.expand_path('../tmp/test', Shaman.spec_root)

        FileUtils.remove_dir(dir, force: true)
        FileUtils.mkdir(dir)

        FileUtils.cd(dir, &block)
        FileUtils.remove_dir(dir)
      end

      def write_config(data, path = Shaman::PROJECT_CONFIG_PATH)
        File.write(path, YAML.dump(data))
      end

      def cp_file_fixture(src)
        FileUtils.cp(File.expand_path("files/#{src}", Shaman.spec_root), Dir.pwd)
      end
    end
  end
end
