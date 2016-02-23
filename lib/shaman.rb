require 'http'
require 'git'
require 'yaml'
require 'shaman/init'
require 'shaman/deploy'
require 'shaman/version'

module Shaman
  PROJECT_CONFIG_PATH = '.shaman.yml'
  LABS_URL =
    case ENV['SHAMAN_ENV']
    when 'development' then 'http://localhost:3000'
    when 'staging' then 'https://labs-staging.infinum.co'
    else
      'https://labs.infinum.co'
    end
end
