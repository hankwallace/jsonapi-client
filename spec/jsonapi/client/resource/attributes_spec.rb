require "spec_helper"

describe JSONAPI::Client::Resource, "attributes" do
  subject do
    Article.new({
      id: "1",
      type: "articles",
      category: "Programming",
      title: "Beginner JSONAPI"
    })
  end

  describe "hash access" do
    it "can get attribute values" do
      expect(subject[:id]).to eq("1")
      expect(subject[:type]).to eq("articles")
      expect(subject[:category]).to eq("Programming")
      expect(subject[:title]).to eq("Beginner JSONAPI")
    end

    it "can set attribute values" do
      subject[:title] = "Beginner JSONAPI vol II"
      expect(subject[:title]).to eq("Beginner JSONAPI vol II")
    end
  end

  describe "dynamic access" do
    it "can get attribute values" do
      expect(subject.id).to eq("1")
      expect(subject.type).to eq("articles")
      expect(subject.category).to eq("Programming")
      expect(subject.title).to eq("Beginner JSONAPI")
    end

    it "can set attribute values" do
      subject.title = "Beginner JSONAPI vol II"
      expect(subject.title).to eq("Beginner JSONAPI vol II")
    end
  end
end
