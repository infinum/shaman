# frozen_string_literal: true

module Shaman
  module Helpers
    def prompt
      Shaman.prompt
    end

    def error!(msg, exit_code = Shaman::CLI::ExitCode::PROCESSING_ERROR)
      prompt.error(msg)
      exit(exit_code)
    end
  end
end
