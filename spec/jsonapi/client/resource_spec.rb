require "spec_helper"

describe JSONAPI::Client::Resource do
  subject { Article }

  let(:url) { "#{subject.url}/articles" }
  let(:headers) do
    { content_type: "application/vnd.api+json" }
  end

  describe "#resource_name" do
    it "has the correct name" do
      expect(subject.resource_name).to eq("article")
    end
  end

  describe "#table_name" do
    it "has the correct name" do
      expect(subject.table_name).to eq("articles")
    end
  end

  # it "has a model_name" do
  #   expect(Article.model_name.name).to eq("article")
  # end

  describe "#create" do
    let(:request_body) do
      {
        data:
          {
            type: "articles",
            attributes:
              {
                title: "Beginner JSONAPI"
              }
          }
      }.to_json
    end
    let(:response_body) do
      {
        data:
          {
            id: "1",
            type: "articles",
            attributes:
              {
                title: "Beginner JSONAPI"
              }
          }
      }.to_json
    end

    it "sends the right request" do
      stub_request(:post, "#{url}").
        with(body: request_body).
        to_return(headers: headers, body: response_body)

      subject.create({ title: "Beginner JSONAPI" })
    end
  end

  describe "#save" do
    context "when creating" do

    end

    context "when updating" do

    end

    # before(:each) do
    #   stub_request(:post, "#{url}").
    #     with(body: request_body).
    #     to_return(headers: headers, body: response_body)
    # end
    #
    # context "using #create" do
    #   it "sends the right request" do
    #     subject.create({ title: "Beginner JSONAPI" })
    #   end
    # end
    #
    # context "using #new and #save" do
    #   it "sends the right request" do
    #     article = Article.new
    #     article.title = "Beginner JSONAPI"
    #     article.save
    #   end
    # end
  end
end
