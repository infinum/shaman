module Shaman
  module TryoutApps
    module Resource
      class Response
        def initialize(response)
          @response = response
        end

        def success?
          response.status.success?
        end

        private

        attr_reader :response
      end
    end
  end
end
