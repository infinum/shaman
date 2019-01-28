require 'http'
require 'git'
require 'yaml'
require 'tty-prompt'
require 'shaman/helpers'
require 'shaman/init'
require 'shaman/deploy'
require 'shaman/version'

module Shaman
  PROJECT_CONFIG_PATH = '.shaman.yml'.freeze
  DEFAULT_URL =
    case ENV['SHAMAN_ENV']
    when 'development' then 'http://localhost:3000'
    when 'staging' then 'https://staging-infinum.tryoutapps.com'
    else
      'https://infinum.tryoutapps.com'
    end
  LABS_URL = ENV['SERVER_URL'] || DEFAULT_URL
end
