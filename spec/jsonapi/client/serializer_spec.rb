require "spec_helper"

describe JSONAPI::Client::Serializer do
  subject { described_class.new(Author, options) }

  describe "#serialize" do
    let(:single_resource) do
      Author.new({
        id: 1,
        first_name: "John",
        last_name: "Doe"
      })
    end
    let(:multiple_resources) do
      [
        Author.new({
          id: 1,
          first_name: "Jane",
          last_name: "Doe"
        }),
        Author.new({
          id: 2,
          first_name: "John",
          last_name: "Doe"
        })
      ]
    end

    context "when keys should be dasherized" do
      let(:options) do
        {
          key_formatter: JSONAPI::Client::DasherizedKeyFormatter
        }
      end

      context "with a single resource" do
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
          body = subject.serialize(single_resource)
          expect(body.to_json).to be_json_eql(expected_body.to_json)
        end
      end

      context "with multiple resources" do
        let(:expected_body) do
          {
            "data" => [{
              "type" => "authors",
              "id" => "1",
              "attributes" => {
                "first-name" => "Jane",
                "last-name" => "Doe"
              }
            }, {
              "type" => "authors",
              "id" => "2",
              "attributes" => {
                "first-name" => "John",
                "last-name" => "Doe"
              }
            }]
          }
        end

        it "dasherizes keys" do
          body = subject.serialize(multiple_resources)
          expect(body.to_json).to be_json_eql(expected_body.to_json)
        end
      end
    end

    context "when keys should be camelized" do
      let(:options) do
        {
          key_formatter: JSONAPI::Client::CamelizedKeyFormatter
        }
      end

      context "with a single resource" do
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
          body = subject.serialize(single_resource)
          expect(body.to_json).to be_json_eql(expected_body.to_json)
        end
      end

      context "with multiple resources" do
        let(:expected_body) do
          {
            "data" => [{
              "type" => "authors",
              "id" => "1",
              "attributes" => {
                "firstName" => "Jane",
                "lastName" => "Doe"
              }
            }, {
              "type" => "authors",
              "id" => "2",
              "attributes" => {
                "firstName" => "John",
                "lastName" => "Doe"
              }
            }]
          }
        end

        it "camelizes keys" do
          body = subject.serialize(multiple_resources)
          expect(body.to_json).to be_json_eql(expected_body.to_json)
        end
      end
    end

    context "when keys should be underscored" do
      let(:options) do
        {
          key_formatter: JSONAPI::Client::UnderscoredKeyFormatter
        }
      end

      context "with a single resource" do
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
          body = subject.serialize(single_resource)
          expect(body.to_json).to be_json_eql(expected_body.to_json)
        end
      end

      context "with multiple resources" do
        let(:expected_body) do
          {
            "data" => [{
              "type" => "authors",
              "id" => "1",
              "attributes" => {
                "first_name" => "Jane",
                "last_name" => "Doe"
              }
            }, {
              "type" => "authors",
              "id" => "2",
              "attributes" => {
                "first_name" => "John",
                "last_name" => "Doe"
              }
            }]
          }
        end

        it "underscores keys" do
          body = subject.serialize(multiple_resources)
          expect(body.to_json).to be_json_eql(expected_body.to_json)
        end
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
