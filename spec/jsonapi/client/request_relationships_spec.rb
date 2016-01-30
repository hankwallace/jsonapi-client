# require "spec_helper"
#
# describe JSONAPI::Client::Request, "relationships" do
#   subject { described_class.new(Article) }
#
#   context "when including a single relationship" do
#     it "can handle a string" do
#       subject.includes("author")
#       expect(subject.params).to eq({ include: "author" })
#     end
#
#     it "can handle a symbol" do
#       subject.includes(:author)
#       expect(subject.params).to eq({ include: "author" })
#     end
#   end
#
#   context "when including multiple relationships" do
#     it "can handle a command-delimited string" do
#       subject.includes("author,comments")
#       expect(subject.params).to eq({ include: "author,comments" })
#     end
#
#     it "can handle multiple strings" do
#       subject.includes("author", "comments")
#       expect(subject.params).to eq({ include: "author,comments" })
#     end
#
#     it "can handle multiple symbols" do
#       subject.includes(:author, :comments)
#       expect(subject.params).to eq({ include: "author,comments" })
#     end
#
#     it "can handle an array of strings" do
#       subject.includes(["author", "comments"])
#       expect(subject.params).to eq({ include: "author,comments" })
#     end
#
#     it "can handle an array of symbols" do
#       subject.includes([:author, :comments])
#       expect(subject.params).to eq({ include: "author,comments" })
#     end
#   end
#
#   it "can chain" do
#     subject.includes(:author).includes(:comments)
#     expect(subject.params).to eq({ include: "author,comments" })
#   end
# end
