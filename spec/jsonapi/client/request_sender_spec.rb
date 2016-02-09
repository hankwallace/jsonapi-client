# require "spec_helper"
#
# describe JSONAPI::Client::RequestSender do
#   describe "route formatting" do
#
#     subject { described_class.new(ExpenseReport) }
#
#     let(:headers) do
#       { content_type: "application/vnd.api+json" }
#     end
#     let(:params) do
#       {}
#     end
#     let(:body) do
#       {
#         data:
#           [
#             {
#               type: "expense-reports",
#               id: "1",
#               attributes:
#                 {
#                   category: "R&D",
#                 }
#             },
#             {
#               id: "2",
#               type: "expense-reports",
#               attributes:
#                 {
#                   category: "R&D",
#                 }
#             }
#           ]
#       }.to_json
#     end
#
#     context "when underscored" do
#       let(:url) { "http://www.example.com/expense_reports" }
#
#       before(:each) do
#         ExpenseReport.route_format = :underscored_route
#       end
#
#       it "sends the right request" do
#         stub_request(:get, url).
#           to_return(headers: headers, body: body)
#
#         subject.get(params)
#       end
#     end
#
#     # context "when camelized" do
#     #   let(:url) { "http://www.example.com/expenseReports" }
#     #
#     #   before(:each) do
#     #     ExpenseReport.route_format = :camelized_route
#     #   end
#     #
#     #   it "sends the right request" do
#     #     stub_request(:get, url).
#     #       to_return(headers: headers, body: body)
#     #
#     #     subject.get(params)
#     #   end
#     # end
#
#     context "when dasherized" do
#       let(:url) { "http://www.example.com/expense-reports" }
#
#       before(:each) do
#         ExpenseReport.route_format = :dasherized_route
#       end
#
#       it "sends the right request" do
#         stub_request(:get, url).
#           to_return(headers: headers, body: body)
#
#         subject.get(params)
#       end
#     end
#   end
# end
