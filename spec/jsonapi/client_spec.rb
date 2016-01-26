require "spec_helper"

describe JSONAPI::Client do
  it "has a version number" do
    expect(JSONAPI::Client::VERSION).not_to be nil
  end
end
