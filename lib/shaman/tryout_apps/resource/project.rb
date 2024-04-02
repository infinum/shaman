require 'json'

module Shaman
  module TryoutApps
    module Resource
      module Project
        class ListResponse < Shaman::TryoutApps::Resource::Response
          def data
            return parse_projects if response.status.success?

            error_message
          end

          private

          attr_reader :response

          def parse_projects
            JSON.parse(response.body).map do |project|
              Shaman::TryoutApps::Resource::Project::Project.new(project)
            end
          end

          def error_message
            response.body.to_s
          end
        end

        class Project
          def initialize(data)
            @data = data
          end

          def name
            data['name']
          end

          def id
            data['id']
          end

          def environments
            @environments ||= data['environments'].map do |environment|
              Shaman::TryoutApps::Resource::Project::Environment.new(environment)
            end
          end

          private

          attr_reader :data
        end

        class Environment
          def initialize(data)
            @data = data
          end

          def name
            data['name']
          end

          def platform
            data['platform']
          end

          def token
            data['token']
          end

          private

          attr_reader :data
        end
      end
    end
  end
end
