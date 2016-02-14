require "spec_helper"

describe JSONAPI::Client::Relation do
  subject { Article }

  let(:url) { "#{subject.url}/articles" }
  let(:headers) do
    { content_type: "application/vnd.api+json" }
  end

  describe "caching" do
    let(:response_body) do
      {
        data: [{
          type: "articles",
          id: "1",
          attributes: {
            title: "Beginner JSONAPI",
            category: "Programming"
          }
        }]
      }.to_json
    end

    it "caches the result" do
      relation = subject.where(category: "Programming")

      stub = stub_request(:get, url).
        with(query: { filter: { "category" => "Programming" } }).
        to_return(headers: headers, body: response_body)
      resources = relation.to_a

      remove_request_stub(stub)
      resources = relation.to_a
    end
  end
end
