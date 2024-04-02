module Shaman
  module TryoutApps
    module Resource
      module Release
        class CreateInput
          def initialize(options)
            @file = options.fetch(:file)
            @environment_token = options.fetch(:environment_token)
            @message = options.fetch(:message)
            @token = options.fetch(:token)
            @minimum_version = options.fetch(:minimum_version)
            @name = options.fetch(:name)
          end

          def form
            {
              release: HTTP::FormData::File.new(file),
              environment_token:,
              message:,
              token:,
              minimum_version:,
              name:
            }
          end

          private

          attr_reader :file
          attr_reader :environment_token
          attr_reader :message
          attr_reader :token
          attr_reader :minimum_version
          attr_reader :name
        end

        class CreateResponse < Shaman::TryoutApps::Resource::Response
          def data
            response.body.to_s
          end
        end
      end
    end
  end
end
