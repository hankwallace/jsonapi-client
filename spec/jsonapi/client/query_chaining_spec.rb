require "spec_helper"

describe JSONAPI::Client::Resource, "query chaining" do
  subject { Article }

  let(:url) { "#{subject.url}/articles" }
  let(:headers) do
    { content_type: "application/vnd.api+json" }
  end

  context "when finding a single resource" do
    let(:response_body) do
      {
        data: {
          id: "1",
          type: "articles",
          attributes: {
            title: "Beginner JSONAPI"
          }
        }
      }.to_json
    end

    describe "#includes #select #find" do
      it "sends the right request" do
        stub_request(:get, "#{url}/1").
          with(query: { include: "author", fields: { "articles" => "title" } }).
          to_return(headers: headers, body: response_body)

        subject.includes(:author).select(:title).find(1)
      end
    end

    describe "#select #find" do
      it "sends the right request" do
        stub_request(:get, "#{url}/1").
          with(query: { fields: { "articles" => "title" } }).
          to_return(headers: headers, body: response_body)

        subject.select(:title).find(1)
      end
    end

    describe "#select #includes #find" do
      it "sends the right request" do
        stub_request(:get, "#{url}/1").
          with(query: { include: "author", fields: { "articles" => "title" } }).
          to_return(headers: headers, body: response_body)

        subject.select(:title).includes(:author).find(1)
      end
    end

    describe "#select #where #find" do
      it "sends the right request" do
        stub_request(:get, "#{url}/1").
          with(query: { fields: { "articles" => "title" }, filter: { "category" => "Programming" } }).
          to_return(headers: headers, body: response_body)

        subject.select(:title).where(category: "Programming").find(1)
      end
    end

    describe "#where #includes #find" do
      it "sends the right request" do
        stub_request(:get, "#{url}/1").
          with(query: { include: "author", filter: { "category" => "Programming" } }).
          to_return(headers: headers, body: response_body)

        subject.where(category: "Programming").includes(:author).find(1)
      end
    end

    describe "#where #order #find" do
      it "sends the right request" do
        stub_request(:get, "#{url}/1").
          with(query: { filter: { "category" => "Programming" }, sort: "title" }).
          to_return(headers: headers, body: response_body)

        subject.where(category: "Programming").order(:title).find(1)
      end
    end

    describe "#where #select #find" do
      it "sends the right request" do
        stub_request(:get, "#{url}/1").
          with(query: { fields: { "articles" => "title" }, filter: { "category" => "Programming" } }).
          to_return(headers: headers, body: response_body)

        subject.where(category: "Programming").select(:title).find(1)
      end
    end

    describe "#where #where #find" do
      it "sends the right request" do
        stub_request(:get, "#{url}/1").
          with(query: { filter: { "category" => "Programming" } }).
          to_return(headers: headers, body: response_body)

        subject.where(category: "Programming").where(category: "Programming").find(1)
      end
    end
  end

  context "when finding multiple resources" do
    let(:response_body) do
      {
        data: [{
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
            title: "Advanced JSONAPI"
          }
        }]
      }.to_json
    end

    context "using #all" do
      describe "#select #where #all" do
        it "sends the right request" do
          stub_request(:get, url).
            with(query: { fields: { "articles" => "title" }, filter: { "category" => "Programming" } }).
            to_return(headers: headers, body: response_body)

          subject.select(:title).where(category: "Programming").all
        end
      end

      describe "#where #order #all" do
        it "sends the right request" do
          stub_request(:get, url).
            with(query: { filter: { "category" => "Programming" }, sort: "title" }).
            to_return(headers: headers, body: response_body)

          subject.where(category: "Programming").order(:title).all
        end
      end

      describe "#where #select #all" do
        it "sends the right request" do
          stub_request(:get, url).
            with(query: { fields: { "articles" => "title" }, filter: { "category" => "Programming" } }).
            to_return(headers: headers, body: response_body)

          subject.where(category: "Programming").select(:title).all
        end
      end
    end

    context "using #find" do
      describe "#select #where #find" do
        it "sends the right request" do
          stub_request(:get, url).
            with(query: { fields: { "articles" => "title" }, filter: { "category" => "Programming", "id" => "1,2" } }).
            to_return(headers: headers, body: response_body)

          subject.select(:title).where(category: "Programming").find(1, 2)
        end
      end
    end

    describe "#where #order #find" do
      it "sends the right request" do
        stub_request(:get, url).
          with(query: { filter: { "category" => "Programming", "id" => "1,2" }, sort: "title" }).
          to_return(headers: headers, body: response_body)

        subject.where(category: "Programming").order(:title).find(1, 2)
      end
    end

    describe "#where #select #find" do
      it "sends the right request" do
        stub_request(:get, url).
          with(query: { fields: { "articles" => "title" }, filter: { "category" => "Programming", "id" => "1,2" } }).
          to_return(headers: headers, body: response_body)

        subject.where(category: "Programming").select(:title).find(1, 2)
      end
    end
  end
end
