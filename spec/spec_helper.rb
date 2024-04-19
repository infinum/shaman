# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'shaman'
require 'tty/prompt/test'
require 'pry'

module Shaman
  def self.spec_root
    __dir__
  end
end

Dir["#{__dir__}/support/**/*.rb"].each { |f| require f }
