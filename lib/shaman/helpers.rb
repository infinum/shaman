module Shaman
  module Helpers
    def prompt
      Shaman.prompt
    end

    def error!(msg)
      prompt.error(msg)
      exit(-1)
    end
  end
end
