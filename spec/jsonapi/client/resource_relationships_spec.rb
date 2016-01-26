# require "spec_helper"
#
# describe JSONAPI::Client::Resource do
#   subject { Article }
#
#   let(:url) { "#{subject.url}/articles" }
#   let(:headers) do
#     { content_type: "application/vnd.api+json" }
#   end
#
#   context "when selecting fields of a relationship" do
#     let(:response_body) do
#       {
#         data:
#           {
#             id: "1",
#             type: "articles",
#             attributes: {
#               title: "Beginner JSONAPI"
#             },
#             links: {
#               self: "http://example.com/articles/1"
#             },
#             relationships: {
#               comments: {
#                 links: {
#                   self: "http://example.com/articles/1/relationships/comments",
#                   related: "http://example.com/articles/1/comments"
#                 },
#                 data: [
#                   { type: "comments", id: "5" },
#                   { type: "comments", id: "12" }
#                 ]
#               }
#             }
#           },
#         included: [{
#           type: "comments",
#           id: "5",
#           attributes: {
#             body: "First!"
#           },
#           links: {
#             self: "http://example.com/comments/5"
#           }
#         }, {
#           type: "comments",
#           id: "12",
#           attributes: {
#             body: "I like XML better"
#           },
#           links: {
#             self: "http://example.com/comments/12"
#           }
#         }]
#       }.to_json
#     end
#
#     it "sends the right request" do
#       stub_request(:get, "#{url}/1").
#         with(query: { include: "comments", fields: { "articles" => "title", "comments" => "body" } }).
#         to_return(headers: headers, body: response_body)
#
#       article = subject.includes("comments").select("title,comments.body").find(1)
#
#       # expect(articles.length).to eq(1)
#       #
#       # expect(articles[0].attributes).to include(:id, :title, :category)
#       # expect(articles[0].attributes).not_to include(:body)
#       # expect(articles[0].id).to eq("1")
#       # expect(articles[0].category).to eq("Programming")
#       # expect(articles[0].title).to eq("Beginner JSONAPI")
#     end
#
#   end
#
# end