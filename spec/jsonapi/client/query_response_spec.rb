require "spec_helper"

describe JSONAPI::Client::Resource, "query response" do
  subject { Article }

  let(:url) { "#{subject.url}/articles" }
  let(:headers) do
    { content_type: "application/vnd.api+json" }
  end

  context "when a single resource is returned" do
    let(:response_body) do
      {
        data: {
          id: "1",
          type: "articles",
          attributes: {
            category: "Programming",
            title: "Beginner JSONAPI"
          }
        }
      }.to_json
    end

    it "processes the response" do
      stub_request(:get, "#{url}/1").
        to_return(headers: headers, body: response_body)

      article = subject.find(1)

      expect(article).to be_a(Article)
      expect(article.id).to eq("1")
      expect(article.category).to eq("Programming")
      expect(article.title).to eq("Beginner JSONAPI")
    end
  end

  context "when multiple resources are returned" do
    let(:response_body) do
      {
        data: [ {
          id: "1",
          type: "articles",
          attributes: {
            category: "Programming",
            title: "Beginner JSONAPI"
          }
        }, {
          type: "articles",
          id: "2",
          attributes: {
            category: "Programming",
            title: "Advanced JSONAPI"
          }
        }]
      }.to_json
    end

    it "processes the response" do
      stub_request(:get, url).
        with(query: { filter: { "id" => "1,2" } }).
        to_return(headers: headers, body: response_body)

      articles = subject.find(1, 2)

      expect(articles.length).to eq(2)

      expect(articles[0].id).to eq("1")
      expect(articles[0].category).to eq("Programming")
      expect(articles[0].title).to eq("Beginner JSONAPI")

      expect(articles[1].id).to eq("2")
      expect(articles[1].category).to eq("Programming")
      expect(articles[1].title).to eq("Advanced JSONAPI")
    end
  end
end
