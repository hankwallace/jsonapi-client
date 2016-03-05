require "spec_helper"

describe JSONAPI::Client::Resource, "query results" do
  subject { Article }

  let(:url) { "#{subject.url}/articles" }
  let(:headers) do
    { content_type: "application/vnd.api+json" }
  end

  context "when finding a single resource" do
    let(:response_body) do
      {
        data: {
          type: "articles",
          id: "1",
          attributes: {
            title: "Beginner JSONAPI"
          }
        }
      }.to_json
    end
    let(:results) { subject.find(1) }

    before(:each) do
      stub_request(:get, "#{url}/1").
        to_return(headers: headers, body: response_body)
    end

    it "is a resource" do
      expect(results).is_a?(Article)
    end
  end

  context "when finding multiple resources" do
    let(:response_body) do
      {
        data: [{
          type: "articles",
          id: "1",
          attributes: {
            title: "Beginner JSONAPI"
          }
        }, {
          type: "articles",
          id: "2",
          attributes: {
            title: "Advanced JSONAPI"
          }
        }]
      }.to_json
    end
    let(:results) { subject.all }

    before(:each) do
      stub_request(:get, url).
        to_return(headers: headers, body: response_body)
    end

    it "is enumerable" do
      expect(results).is_a?(Enumerable)
      expect(results.each).is_a?(Enumerator)
      expect(results.any? { |a| a.id == "1" }).to be(true)
    end

    it "behaves like an array" do
      expect(results.empty?).to be(false)
      expect(results.length).to eq(2)
      expect(results.first.id).to eq("1")
      expect(results.last.id).to eq("2")
    end

    it "has no errors" do
      expect(results.status).to be(200)
      expect(results.has_errors?).to be(false)
    end
  end

  context "when errors occur" do

  end
end
