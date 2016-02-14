require "spec_helper"

describe JSONAPI::Client::Resource, "serialization" do
  describe "#as_jsonapi" do
    subject do
      Author.new({
        id: 1,
        first_name: "John",
        last_name: "Doe"
      }).as_jsonapi(options)
    end

    context "when keys should be dasherized" do
      let(:options) do
        {
          key_formatter: JSONAPI::Client::DasherizedKeyFormatter
        }
      end
      let(:expected_json) do
        {
          "type" => "authors",
          "id" => "1",
          "attributes" => {
            "first-name" => "John",
            "last-name" => "Doe"
          }
        }
      end

      it "serializes correctly" do
        expect(subject.to_json).to be_json_eql(expected_json.to_json)
      end
    end

    context "when keys should be camelized" do
      let(:options) do
        {
          key_formatter: JSONAPI::Client::CamelizedKeyFormatter
        }
      end
      let(:expected_json) do
        {
          "type" => "authors",
          "id" => "1",
          "attributes" => {
            "firstName" => "John",
            "lastName" => "Doe"
          }
        }
      end

      it "serializes correctly" do
        expect(subject.to_json).to be_json_eql(expected_json.to_json)
      end
    end

    context "when keys should be underscored" do
      let(:options) do
        {
          key_formatter: JSONAPI::Client::UnderscoredKeyFormatter
        }
      end
      let(:expected_json) do
        {
          "type" => "authors",
          "id" => "1",
          "attributes" => {
            "first_name" => "John",
            "last_name" => "Doe"
          }
        }
      end

      it "serializes correctly" do
        expect(subject.to_json).to be_json_eql(expected_json.to_json)
      end
    end
  end

  describe "#from_jsonapi" do
    subject { Author.new }

    let(:expected_attributes) do
      {
        "type" => "authors",
        "id" => "1",
        "first_name" => "John",
        "last_name" => "Doe"
      }
    end

    context "when keys are dasherized" do
      let(:json) do
        {
          "type" => "authors",
          "id" => "1",
          "attributes" => {
            "first-name" => "John",
            "last-name" => "Doe"
          }
        }
      end
      let(:options) do
        {
          key_formatter: JSONAPI::Client::UnderscoredKeyFormatter
        }
      end

      it "deserializes correctly" do
        subject.from_jsonapi(json)
        expect(subject.attributes).to eq(expected_attributes)
      end
    end

    context "when keys are camelized" do
      let(:json) do
        {
          "type" => "authors",
          "id" => "1",
          "attributes" => {
            "firstName" => "John",
            "lastName" => "Doe"
          }
        }
      end
      let(:options) do
        {
          key_formatter: JSONAPI::Client::UnderscoredKeyFormatter
        }
      end

      it "deserializes correctly" do
        subject.from_jsonapi(json)
        expect(subject.attributes).to eq(expected_attributes)
      end
    end

    context "when keys are underscored" do
      let(:json) do
        {
          "type" => "authors",
          "id" => "1",
          "attributes" => {
            "first_name" => "John",
            "last_name" => "Doe"
          }
        }
      end
      let(:options) do
        {
          key_formatter: JSONAPI::Client::UnderscoredKeyFormatter
        }
      end

      it "deserializes correctly" do
        subject.from_jsonapi(json)
        expect(subject.attributes).to eq(expected_attributes)
      end
    end
  end
end
