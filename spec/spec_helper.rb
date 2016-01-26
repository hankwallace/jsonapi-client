$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "simplecov"
require "faraday"
require "webmock"
require "webmock/rspec"
require "json_spec"
require "jsonapi-client"

SimpleCov.start do
  add_filter "/spec/"
  minimum_coverage 100
end

# WebMock.disable_net_connect!

class NullConnection
  def initialize(*); end
  def get(*); end
end

# class NullParser
#   def self.parse(*); end
# end

# Sample models taken from the JSONAPI spec examples
class Article < JSONAPI::Client::Resource
  self.url = "http://www.example.com"
end

class Author < JSONAPI::Client::Resource
  self.url = "http://www.example.com"
end


RSpec.configure do |config|
  config.include JsonSpec::Helpers

  config.before(:each) do
    Article.instance_variable_set(:@connection, nil)
  end
end
