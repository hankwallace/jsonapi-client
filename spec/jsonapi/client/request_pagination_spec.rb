# require "spec_helper"
#
# describe JSONAPI::Client::Request, "pagination" do
#   subject { described_class.new(Article) }
#
#   context "with page number and size" do
#     it "can paginate" do
#       subject.page(2).per(20)
#       expect(subject.params).to eq({ page: { number: 2, size: 20 } })
#     end
#   end
#
#   context "with offset and limit" do
#     it "can paginate" do
#       subject.offset(10).limit(20)
#       expect(subject.params).to eq({ page: { offset: 10, limit: 20 } })
#     end
#   end
# end
