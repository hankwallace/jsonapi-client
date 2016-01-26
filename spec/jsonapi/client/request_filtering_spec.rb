require "spec_helper"

describe JSONAPI::Client::Request, "filtering" do
  subject { described_class.new(Article) }

  context "when filtering by a single value" do
    it "can handle a single string" do
      subject.where(category: "Programming")
      expect(subject.params).to eq({ filter: { category: "Programming" } })
    end

    it "can handle a single symbol" do
      subject.where(category: :Programming)
      expect(subject.params).to eq({ filter: { category: "Programming" } })
    end
  end

  context "when filtering by multiple values" do
    it "can handle a command-delimited string" do
      subject.where(category: "Programming,Management")
      expect(subject.params).to eq({ filter: { category: "Programming,Management" } })
    end

    it "can handle an array of strings" do
      subject.where(category: ["Programming", "Management"])
      expect(subject.params).to eq({ filter: { category: "Programming,Management" } })
    end

    it "can handle an array of symbols" do
      subject.where(category: [:Programming, :Management])
      expect(subject.params).to eq({ filter: { category: "Programming,Management" } })
    end
  end

  it "can chain" do
    subject.where(category: "Programming").where(published: true)
    expect(subject.params).to eq({ filter: { category: "Programming", published: "true" } })
  end
end
