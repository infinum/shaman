# frozen_string_literal: true

module Shaman
  module TryoutApps
    class Client
      def initialize(base_uri)
        @base_uri = base_uri
      end

      def list_projects(params)
        Shaman::TryoutApps::Resource::Project::ListResponse.new(
          HTTP.get("#{base_uri}/api/v1/projects", params:)
        )
      end

      def create_release(release)
        Shaman::TryoutApps::Resource::Release::CreateResponse.new(
          HTTP.post("#{base_uri}/api/v1/releases", form: release.form)
        )
      end

      private

      attr_reader :base_uri
    end
  end
end
