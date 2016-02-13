require "spec_helper"

describe JSONAPI::Client::Resource, "query" do
  subject { Article }

  let(:url) { "#{subject.url}/articles" }
  let(:headers) do
    { content_type: "application/vnd.api+json" }
  end

  describe "#find" do
    context "when no ID is specified" do
      it "raises an exception" do
        expect do
          subject.find
        end.to raise_exception(JSONAPI::Client::RecordNotFound)
      end
    end

    context "when finding a single resource" do
      let(:response_body) do
        {
          data: {
            type: "articles",
            id: "1",
            attributes: {
              title: "Beginner JSONAPI"
            }
          }
        }.to_json
      end

      it "sends the right request" do
        stub_request(:get, "#{url}/1").
          to_return(headers: headers, body: response_body)

        subject.find(1)
      end

      context "when resource is not found" do
        let(:response_body) do
          {}.to_json
        end

        it "raises an exception" do
          stub_request(:get, "#{url}/1").
            to_return(headers: headers, body: response_body)

          expect do
            subject.find(1)
          end.to raise_exception(JSONAPI::Client::RecordNotFound, /Couldn't find Article/)
        end
      end
    end

    context "when finding multiple resources" do
      let(:response_body) do
        {
          data: [{
            type: "articles",
            id: "1",
            attributes: {
              title: "Beginner JSONAPI"
            }
          }, {
            type: "articles",
            id: "2",
            attributes: {
              title: "Advanced JSONAPI"
            }
          }]
        }.to_json
      end

      it "sends the right request" do
        stub_request(:get, url).
          with(query: { filter: { "id" => "1,2" } }).
          to_return(headers: headers, body: response_body)

        subject.find(1, 2)
      end

      context "when resources are not found" do
        let(:response_body) do
          {
            data: [{
              type: "articles",
              id: "1",
              attributes: {
                title: "Beginner JSONAPI"
              }
            }]
          }.to_json
        end

        it "raises an exception" do
          stub_request(:get, url).
            with(query: { filter: { "id" => "1,3" } }).
            to_return(headers: headers, body: response_body)

          expect do
            subject.find(1, 3)
          end.to raise_exception(JSONAPI::Client::RecordNotFound, /Couldn't find all Articles/)
        end
      end
    end
  end

  describe "#find_by" do
    let(:response_body) do
      {
        data: {
          type: "articles",
          id: "1",
          attributes: {
            title: "Beginner JSONAPI",
            category: "Programming"
          }
        }
      }.to_json
    end

    context "when filtering by a single value" do
      before(:each) do
        stub_request(:get, url).
          with(query: { filter: { "category" => "Programming" }, page: { "limit" => 1 } }).
          to_return(headers: headers, body: response_body)
      end

      context "with a string" do
        it "sends the right request" do
          subject.find_by(category: "Programming")
        end
      end

      context "with a symbol" do
        it "sends the right request" do
          subject.find_by(category: :Programming)
        end
      end
    end

    context "when filtering by multiple values" do
      before(:each) do
        stub_request(:get, url).
          with(query: { filter: { "category" => "Programming,Management" }, page: { "limit" => 1 } }).
          to_return(headers: headers, body: response_body)
      end

      context "with strings" do
        it "sends the right request" do
          subject.find_by(category: %w(Programming Management))
        end
      end

      context "with symbols" do
        it "sends the right request" do
          subject.find_by(category: [:Programming, :Management])
        end
      end
    end

    context "when resource is not found" do
      let(:response_body) do
        {}.to_json
      end

      before(:each) do
        stub_request(:get, url).
          with(query: { filter: { "category" => "Programming" }, page: { "limit" => 1 } }).
          to_return(headers: headers, body: response_body)
      end

      it "returns nil" do
        expect(subject.find_by(category: :Programming)).to be_nil
      end
    end
  end

  describe "#find_by!" do
    let(:response_body) do
      {
        data: {
          type: "articles",
          id: "1",
          attributes: {
            title: "Beginner JSONAPI",
            category: "Programming"
          }
        }
      }.to_json
    end

    context "when filtering by a single value" do
      before(:each) do
        stub_request(:get, url).
          with(query: { filter: { "category" => "Programming" }, page: { "limit" => 1 } }).
          to_return(headers: headers, body: response_body)
      end

      context "with a string" do
        it "sends the right request" do
          subject.find_by!(category: "Programming")
        end
      end

      context "with a symbol" do
        it "sends the right request" do
          subject.find_by!(category: :Programming)
        end
      end

      context "when resource is not found" do
        let(:response_body) do
          {}.to_json
        end

        it "raises an exception" do
          stub_request(:get, url).
            with(query: { filter: { "category" => "Management" }, page: { "limit" => 1 } }).
            to_return(headers: headers, body: response_body)

          expect do
            subject.find_by!(category: :Management)
          end.to raise_exception(JSONAPI::Client::RecordNotFound, /Couldn't find Article/)
        end
      end
    end
  end

  describe "#take" do
    let(:response_body) do
      {
        data: [{
          type: "articles",
          id: "1",
          attributes: {
            title: "Beginner JSONAPI"
          }
        }, {
          type: "articles",
          id: "2",
          attributes: {
            title: "Advanced JSONAPI"
          }
        }]
      }.to_json
    end
    let(:limit) { 1 }

    before(:each) do
      stub_request(:get, url).
        with(query: { page: { "limit" => limit } }).
        to_return(headers: headers, body: response_body)
    end

    context "when no limit is specified" do
      let(:response_body) do
        {
          data: {
            type: "articles",
            id: "1",
            attributes: {
              title: "Beginner JSONAPI"
            }
          }
        }.to_json
      end

      it "sends the right request" do
        subject.take
      end
    end

    context "when a limit is specified" do
      let(:limit) { 2 }

      it "sends the right request" do
        subject.take(2)
      end
    end

    context "when resource is not found" do
      let(:response_body) do
        {}.to_json
      end

      it "returns nil" do
        expect(subject.take).to be_nil
      end
    end
  end

  describe "#take!" do
    let(:response_body) do
      {
        data: {
          type: "articles",
          id: "1",
          attributes: {
            title: "Beginner JSONAPI"
          }
        }
      }.to_json
    end

    before(:each) do
      stub_request(:get, url).
        with(query: { page: { "limit" => 1 } }).
        to_return(headers: headers, body: response_body)
    end

    it "sends the right request" do
      subject.take!
    end

    context "when resource is not found" do
      let(:response_body) do
        {}.to_json
      end

      it "raises an exception" do
        expect do
          subject.take!
        end.to raise_exception(JSONAPI::Client::RecordNotFound, /Couldn't find Article/)
      end
    end
  end

  describe "#first" do
    let(:response_body) do
      {
        data: [{
          type: "articles",
          id: "1",
          attributes: {
            title: "Beginner JSONAPI"
          }
        }, {
          type: "articles",
          id: "2",
          attributes: {
            title: "Advanced JSONAPI"
          }
        }]
      }.to_json
    end
    let(:limit) { 1 }

    before(:each) do
      stub_request(:get, url).
        with(query: { page: { "limit" => limit }, sort: "id" }).
        to_return(headers: headers, body: response_body)
    end

    context "when no limit is specified" do
      it "sends the right request" do
        subject.first
      end
    end

    context "when a limit is specified" do
      let(:limit) { 2 }

      it "sends the right request" do
        subject.first(limit)
      end
    end

    context "when resource is not found" do
      let(:response_body) do
        {}.to_json
      end

      it "returns nil" do
        expect(subject.first).to be_nil
      end
    end
  end

  describe "#first!" do
    let(:response_body) do
      {
        data: [{
          type: "articles",
          id: "1",
          attributes: {
            title: "Beginner JSONAPI"
          }
        }, {
          type: "articles",
          id: "2",
          attributes: {
            title: "Advanced JSONAPI"
          }
        }]
      }.to_json
    end

    before(:each) do
      stub_request(:get, url).
        with(query: { page: { "limit" => 1 }, sort: "id" }).
        to_return(headers: headers, body: response_body)
    end

    it "sends the right request" do
      subject.first!
    end

    context "when resource is not found" do
      let(:response_body) do
        {}.to_json
      end

      it "raises an exception" do
        expect do
          subject.first!
        end.to raise_exception(JSONAPI::Client::RecordNotFound, /Couldn't find Article/)
      end
    end
  end

  describe "#last" do
    let(:response_body) do
      {
        data: [{
          type: "articles",
          id: "1",
          attributes: {
            title: "Beginner JSONAPI"
          }
        }, {
          type: "articles",
          id: "2",
          attributes: {
            title: "Advanced JSONAPI"
          }
        }]
      }.to_json
    end
    let(:limit) { 1 }

    before(:each) do
      stub_request(:get, url).
        with(query: { page: { "limit" => limit }, sort: "-id" }).
        to_return(headers: headers, body: response_body)
    end

    context "when no limit is specified" do
      it "sends the right request" do
        subject.last
      end
    end

    context "when a limit is specified" do
      let(:limit) { 2 }

      it "sends the right request" do
        subject.last(limit)
      end
    end

    context "when resource is not found" do
      let(:response_body) do
        {}.to_json
      end

      it "returns nil" do
        expect(subject.last).to be_nil
      end
    end
  end

  describe "#last!" do
    let(:response_body) do
      {
        data: [{
          type: "articles",
          id: "1",
          attributes: {
            title: "Beginner JSONAPI"
          }
        }, {
          type: "articles",
          id: "2",
          attributes: {
            title: "Advanced JSONAPI"
          }
        }]
      }.to_json
    end

    before(:each) do
      stub_request(:get, url).
        with(query: { page: { "limit" => 1 }, sort: "-id" }).
        to_return(headers: headers, body: response_body)
    end

    it "sends the right request" do
      subject.last!
    end

    context "when resource is not found" do
      let(:response_body) do
        {}.to_json
      end

      it "raises an exception" do
        expect do
          subject.last!
        end.to raise_exception(JSONAPI::Client::RecordNotFound, /Couldn't find Article/)
      end
    end
  end

  describe "#second" do
    let(:response_body) do
      {
        data: [{
          type: "articles",
          id: "1",
          attributes: {
            title: "Beginner JSONAPI"
          }
        }, {
          type: "articles",
          id: "2",
          attributes: {
            title: "Advanced JSONAPI"
          }
        }]
      }.to_json
    end
    let(:limit) { 1 }

    before(:each) do
      stub_request(:get, url).
        with(query: { page: { "limit" => limit, "offset" => 1 }, sort: "id" }).
        to_return(headers: headers, body: response_body)
    end

    it "sends the right request" do
      subject.second
    end

    context "when resource is not found" do
      let(:response_body) do
        {}.to_json
      end

      it "returns nil" do
        expect(subject.second).to be_nil
      end
    end

  end

  describe "#second!" do
    let(:response_body) do
      {
        data: [{
          type: "articles",
          id: "1",
          attributes: {
            title: "Beginner JSONAPI"
          }
        }, {
          type: "articles",
          id: "2",
          attributes: {
            title: "Advanced JSONAPI"
          }
        }]
      }.to_json
    end

    before(:each) do
      stub_request(:get, url).
        with(query: { page: { "limit" => 1, "offset" => 1 }, sort: "id" }).
        to_return(headers: headers, body: response_body)
    end

    it "sends the right request" do
      subject.second!
    end

    context "when resource is not found" do
      let(:response_body) do
        {}.to_json
      end

      it "raises an exception" do
        expect do
          subject.second!
        end.to raise_exception(JSONAPI::Client::RecordNotFound, /Couldn't find Article/)
      end
    end
  end

  describe "#includes" do
    context "when finding a single resource" do
      let(:response_body) do
        {
          data: {
            type: "articles",
            id: "1",
            attributes: {
              title: "Beginner JSONAPI"
            },
            relationships: {
              author: {
                data: {
                  type: "people",
                  id: "9"
                }
              },
              comments: {
                data: [{
                  type: "comments",
                  id: "5"
                }, {
                  type: "comments",
                  id: "12"
                }]
              }
            }
          }
        }.to_json
      end

      context "when including a single relationship" do
        before(:each) do
          stub_request(:get, "#{url}/1").
            with(query: { include: "author" }).
            to_return(headers: headers, body: response_body)
        end

        context "with a string" do
          it "sends the right request" do
            subject.includes("author").find(1)
          end
        end

        context "with a symbol" do
          it "sends the right request" do
            subject.includes(:author).find(1)
          end
        end
      end

      context "when including multiple relationships" do
        before(:each) do
          stub_request(:get, "#{url}/1").
            with(query: { include: "author,comments" }).
            to_return(headers: headers, body: response_body)
        end

        context "with a comma-delimited string" do
          it "sends the right request" do
            subject.includes("author, comments").find(1)
          end
        end

        context "with an array of strings" do
          it "sends the right request" do
            subject.includes("author", "comments").find(1)
          end
        end

        context "with an array of symbols" do
          it "sends the right request" do
            subject.includes(:author, :comments).find(1)
          end
        end
      end
    end

    context "when finding multiple resources" do
      let(:response_body) do
        {
          data: [{
            type: "articles",
            id: "1",
            attributes: {
              title: "Beginner JSONAPI"
            },
            relationships: {
              author: {
                data: {
                  type: "people",
                  id: "9"
                }
              }
            }
          }, {
            type: "articles",
            id: "2",
            attributes: {
              title: "Advanced JSONAPI"
            },
            relationships: {
              author: {
                data: {
                  type: "people",
                  id: "7"
                }
              }
            }
          }]
        }.to_json
      end

      it "sends the right request" do
        stub_request(:get, "#{url}").
          with(query: { include: "author" }).
          to_return(headers: headers, body: response_body)

        subject.includes(:author).all
      end
    end
  end

  describe "#order" do
    let(:response_body) do
      {
        data: {
          type: "articles",
          id: "1",
          attributes: {
            category: "Programming",
            title: "Beginner JSONAPI"
          }
        }
      }.to_json
    end

    context "with no argument" do
      it "raises an exception" do
        expect do
          subject.order
        end.to raise_exception(ArgumentError, "The method .order() must contain arguments.")
      end
    end

    context "when sorting by a single field" do
      context "with no order" do
        it "sends the right request" do
          stub_request(:get, url).
            with(query: { sort: "title" }).
            to_return(headers: headers, body: response_body)

          subject.order(:title).all
        end
      end

      context "with an invalid order" do
        it "raises an exception" do
          expect do
            subject.order(title: :foo).all
          end.to raise_exception(ArgumentError, "Direction \"foo\" is invalid.")
        end
      end

      context "when sorting asc" do
        it "sends the right request" do
          stub_request(:get, url).
            with(query: { sort: "title" }).
            to_return(headers: headers, body: response_body)

          subject.order(title: :asc).all
        end
      end

      context "when sorting desc" do
        it "sends the right request" do
          stub_request(:get, url).
            with(query: { sort: "-title" }).
            to_return(headers: headers, body: response_body)

          subject.order(title: :desc).all
        end
      end
    end

    context "when sorting by multiple fields" do
      context "with no order" do
        it "sends the right request" do
          stub_request(:get, url).
            with(query: { sort: "category,title" }).
            to_return(headers: headers, body: response_body)

          subject.order(:category, :title).all
        end
      end

      context "when sorting asc" do
        it "sends the right request" do
          stub_request(:get, url).
            with(query: { sort: "category,title" }).
            to_return(headers: headers, body: response_body)

          subject.order(category: :asc, title: :asc).all
        end
      end

      context "when sorting desc" do
        it "sends the right request" do
          stub_request(:get, url).
            with(query: { sort: "-category,-title" }).
            to_return(headers: headers, body: response_body)

          subject.order(category: :desc, title: :desc).all
        end
      end

      context "when sorting mixed" do
        it "sends the right request" do
          stub_request(:get, url).
            with(query: { sort: "category,-title" }).
            to_return(headers: headers, body: response_body)

          subject.order(category: :asc, title: :desc).all
        end
      end
    end
  end

  describe "#offset and #limit" do
    # it "can paginate" do
    #   stub_request(:get, url).
    #     with(query: { filter: { "category" => "Programming" } }).
    #     to_return(headers: headers, body: response_body)
    #
    #   subject.offset(10).limit(2).all
    # end

    context "when using #find" do
        let(:response_body) do
          {
            data: [{
              type: "articles",
              id: "1",
              attributes: {
                title: "Beginner JSONAPI"
              }
            }, {
              type: "articles",
              id: "2",
              attributes: {
                title: "Advanced JSONAPI"
              }
            }]
          }.to_json
        end

      context "when limit is less than ids size" do
        it "sends the right request" do
          stub_request(:get, url).
            with(query: { filter: { "id" => "1,2,3" }, page: { "limit" => 2 } }).
            to_return(headers: headers, body: response_body)

          subject.limit(2).find(1, 2, 3)
        end

        context "when an offset is also specified" do
          let(:ids) { Array(1..11) }

          before(:each) do
            stub_request(:get, url).
              with(query: { filter: { "id" => ids.join(",") }, page: { "limit" => 3, "offset" => 9 } }).
              to_return(headers: headers, body: response_body)
          end

          context "with #offset and #limit" do
            it "sends the right request" do
              subject.offset(9).limit(3).find(ids)
            end
          end

          context "with #limit and #offset" do
            it "sends the right request" do
              subject.limit(3).offset(9).find(ids)
            end
          end
        end
      end

      context "when one or more of the resources are not found" do
        it "raises an exception" do
          ids = Array(1..4)

          stub_request(:get, url).
            with(query: { filter: { "id" => ids.join(",") }, page: { "limit" => 3 } }).
            to_return(headers: headers, body: response_body)

          expect do
            subject.limit(3).find(ids)
          end.to raise_exception(JSONAPI::Client::RecordNotFound, /Couldn't find all Articles/)
        end
      end
    end
  end

  describe "#where" do
    context "with no argument" do
      it "raises an exception" do
        expect do
          subject.where
        end.to raise_exception(ArgumentError, "The method .where() must contain arguments.")
      end
    end

    context "when filtering by a single value" do
      let(:response_body) do
        {
          data: {
            type: "articles",
            id: "1",
            attributes: {
              category: "Programming",
              title: "Beginner JSONAPI"
            }
          }
        }.to_json
      end

      before(:each) do
        stub_request(:get, url).
          with(query: { filter: { "category" => "Programming" } }).
          to_return(headers: headers, body: response_body)
      end

      context "with a string" do
        it "sends the right request" do
          subject.where(category: "Programming").all
        end
      end

      context "with a symbol" do
        it "sends the right request" do
          subject.where(category: :Programming).all
        end
      end
    end

    context "when filtering by multiple values" do
      let(:response_body) do
        {
          data: [{
            type: "articles",
            id: "1",
            attributes: {
              category: "Programming",
              title: "Beginner JSONAPI"
            }
          }, {
            type: "articles",
            id: "2",
            attributes: {
              category: "Programming",
              title: "Advanced JSONAPI"
            }
          }]
        }.to_json
      end

      before(:each) do
        stub_request(:get, url).
          with(query: { filter: { "category" => "Programming,Management" } }).
          to_return(headers: headers, body: response_body)
      end

      context "with a comma-delimited string" do
        it "sends the right request" do
          # TODO: Does Rails handle it when there is a space after the comma? Currently, I don't!
          # Maybe I need to do a .split(',').map(&:strip).join(',') in there?!
          subject.where(category: "Programming,Management").all
        end
      end

      context "with an array of strings" do
        it "sends the right request" do
          subject.where(category: %w(Programming Management)).all
        end
      end

      context "with an array of symbols" do
        it "sends the right request" do
          subject.where(category: [:Programming, :Management]).all
        end
      end
    end
  end

  describe "#select" do
    context "with no argument" do
      it "raises an exception" do
        expect do
          subject.select
        end.to raise_exception(ArgumentError, "The method .select() must contain arguments.")
      end
    end

    context "when selecting a single field" do
      let(:response_body) do
        {
          data: {
            type: "articles",
            id: "1",
            attributes: {
              title: "Beginner JSONAPI"
            }
          }
        }.to_json
      end

      context "with a string" do
        it "sends the right request" do
          stub_request(:get, url).
            with(query: { fields: { "articles" => "title" } }) #.

          subject.select("title").all
        end

      end

      context "with a symbol" do
        it "sends the right request" do
          stub_request(:get, url).
            with(query: { fields: { "articles" => :title } }) #.

          subject.select(:title).all
        end
      end
    end

    context "when selecting mutliple fields" do
      let(:response_body) do
        {
          data: {
            type: "articles",
            id: "1",
            attributes: {
              category: "Programming",
              title: "Beginner JSONAPI"
            }
          }
        }.to_json
      end

      context "with comma-delimited string" do
        it "sends the right request" do
          stub_request(:get, url).
            with(query: { fields: { "articles" => "title,category" } })

          subject.select("title, category").all
        end
      end

      context "with an array of strings" do
        it "sends the right request" do
          stub_request(:get, url).
            with(query: { fields: { "articles" => "title,category" } })

          subject.select("title", "category").all
        end
      end

      context "with an array of symbols" do
        it "sends the right request" do
          stub_request(:get, url).
            with(query: { fields: { "articles" => "title,category" } })

          subject.select(:title, :category).all
        end
      end
    end
  end
end
