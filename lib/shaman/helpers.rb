module Shaman
  module Helpers
    def prompt
      @prompt ||= TTY::Prompt.new
    end

    def error!(msg)
      prompt.error(msg)
      exit(-1)
    end
  end
end
