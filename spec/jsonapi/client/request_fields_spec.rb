# require "spec_helper"
#
# describe JSONAPI::Client::Request, "sparse fieldsets" do
#   subject { described_class.new(Article) }
#
#   context "when selecting a single field" do
#     it "can handle a single string" do
#       subject.select("title")
#       expect(subject.params).to eq({ fields: { "articles" => "title" } })
#     end
#
#     it "can handle a single symbol" do
#       subject.select(:title)
#       expect(subject.params).to eq({ fields: { "articles" => "title" } })
#     end
#   end
#
#   context "when selecting multiple fields" do
#     it "can handle a command-delimited string" do
#       subject.select("title,category")
#       expect(subject.params).to eq({ fields: { "articles" => "title,category" } })
#     end
#
#     it "can handle multiple strings" do
#       subject.select("title", "category")
#       expect(subject.params).to eq({ fields: { "articles" => "title,category" } })
#     end
#
#     it "can handle multiple symbols" do
#       subject.select(:title, :category)
#       expect(subject.params).to eq({ fields: { "articles" => "title,category" } })
#     end
#
#     it "can handle an array of strings" do
#       subject.select(["title", "category"])
#       expect(subject.params).to eq({ fields: { "articles" => "title,category" } })
#     end
#
#     it "can handle an array of symbols" do
#       subject.select([:title, :category])
#       expect(subject.params).to eq({ fields: { "articles" => "title,category" } })
#     end
#   end
#
#   it "can chain" do
#     subject.select(:title).select(:category)
#     expect(subject.params).to eq({ fields: { "articles" => "title,category" } })
#   end
# end
