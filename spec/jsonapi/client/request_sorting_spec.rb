require "spec_helper"

describe JSONAPI::Client::Request, "sorting" do
  subject { described_class.new(Article) }

  it "can sort asc" do
    subject.order(title: :asc)
    expect(subject.params).to eq({ sort: "title" })
  end

  it "can sort desc" do
    subject.order(title: :desc)
    expect(subject.params).to eq({ sort: "-title" })
  end

  it "defaults to sort asc" do
    subject.order(:title)
    expect(subject.params).to eq({ sort: "title" })
  end

  it "can sort multiple" do
    subject.order(title: :asc, category: :desc)
    expect(subject.params).to eq({ sort: "title,-category" })
  end

  it "can chain" do
    subject.order(title: :desc).order(:category)
    expect(subject.params).to eq({ sort: "-title,category" })
  end

  it "prevents invalid directions" do
    expect do
      subject.order(title: :both)
    end.to raise_error(ArgumentError)
  end
end
