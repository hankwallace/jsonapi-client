require "spec_helper"

describe JSONAPI::Client::Serializer do
  subject { described_class.new(Author, options) }

  describe "#serialize" do
    let(:resource) do
      Author.new({
        id: 1,
        first_name: "John",
        last_name: "Doe"
      })
    end

    context "when keys should be dasherized" do
      let(:options) do
        {
          key_formatter: JSONAPI::Client::DasherizedKeyFormatter
        }
      end
      let(:expected_body) do
        {
          "data" => {
            "type" => "authors",
            "id" => "1",
            "attributes" => {
              "first-name" => "John",
              "last-name" => "Doe"
            }
          }
        }
      end

      it "dasherizes keys" do
        body = subject.serialize(resource)
        expect(body.to_json).to be_json_eql(expected_body.to_json)
      end
    end

    context "when keys should be camelized" do
      let(:options) do
        {
          key_formatter: JSONAPI::Client::CamelizedKeyFormatter
        }
      end
      let(:expected_body) do
        {
          "data" => {
            "type" => "authors",
            "id" => "1",
            "attributes" => {
              "firstName" => "John",
              "lastName" => "Doe"
            }
          }
        }
      end

      it "camelizes keys" do
        body = subject.serialize(resource)
        expect(body.to_json).to be_json_eql(expected_body.to_json)
      end
    end

    context "when keys should be underscored" do
      let(:options) do
        {
          key_formatter: JSONAPI::Client::UnderscoredKeyFormatter
        }
      end
      let(:expected_body) do
        {
          "data" => {
            "type" => "authors",
            "id" => "1",
            "attributes" => {
              "first_name" => "John",
              "last_name" => "Doe"
            }
          }
        }
      end

      it "underscores keys" do
        body = subject.serialize(resource)
        expect(body.to_json).to be_json_eql(expected_body.to_json)
      end
    end
  end

  describe "#deserialize" do
    context "when keys are dasherized" do
      let(:body) do
        {
          "data" => [{
            "type" => "authors",
            "id" => "1",
            "attributes" => {
              "first-name" => "John",
              "last-name" => "Doe"
            }
          }]
        }
      end
      let(:options) do
        {
          key_formatter: JSONAPI::Client::UnderscoredKeyFormatter
        }
      end

      it "underscores keys" do
        authors = subject.deserialize(body)
        expect(authors.length).to eq(1)
        expect(authors[0].attributes).to include("first_name", "last_name")
      end
    end

    context "when keys are camelized" do
      let(:body) do
        {
          "data" => [{
            "type" => "authors",
            "id" => "1",
            "attributes" => {
              "firstName" => "John",
              "lastName" => "Doe"
            }
          }]
        }
      end
      let(:options) do
        {
          key_formatter: JSONAPI::Client::UnderscoredKeyFormatter
        }
      end

      it "unformats keys" do
        authors = subject.deserialize(body)
        expect(authors.length).to eq(1)
        expect(authors[0].attributes).to include("first_name", "last_name")
      end
    end

    context "when keys are underscored" do
      let(:body) do
        {
          "data" => [{
            "type" => "authors",
            "id" => "1",
            "attributes" => {
              "first_name" => "John",
              "last_name" => "Doe"
            }
          }]
        }
      end
      let(:options) do
        {
          key_formatter: JSONAPI::Client::UnderscoredKeyFormatter
        }
      end

      it "underscores keys" do
        authors = subject.deserialize(body)
        expect(authors.length).to eq(1)
        expect(authors[0].attributes).to include("first_name", "last_name")
      end
    end
  end
end
