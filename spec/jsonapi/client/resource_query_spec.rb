require "spec_helper"

describe JSONAPI::Client::Resource do
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
          data:
            {
              id: "1",
              type: "articles",
              attributes:
                {
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

      # TODO: Cover these in the other methods (where, select)
      # context "when chaining" do
      #   context "with #select" do
      #
      #   end
      #
      #   context "with #where" do
      #     before(:each) do
      #       stub_request(:get, "#{url}").
      #         with(query: { filter: { "category" => "Programming", "id" => "1" } }).
      #         to_return(headers: headers, body: response_body)
      #     end
      #
      #     it "sends the right request" do
      #       subject.where(category: "Programming").find(1)
      #     end
      #   end
      # end
    end

    context "when finding multiple resources" do
      let(:response_body) do
        {
          data:
            [
              {
                id: "1",
                type: "articles",
                attributes:
                  {
                    title: "Beginner JSONAPI"
                  }
              },
              {
                type: "articles",
                id: "2",
                attributes:
                  {
                    title: "Advanced JSONAPI"
                  }
              }
            ]
        }.to_json
      end

      it "sends the right request" do
        stub_request(:get, url).
          with(query: { filter: { "id" => "1,2" } }).
          to_return(headers: headers, body: response_body)

        subject.find(1, 2)
      end

      # context "when resource is not found" do
      #   it "raises an exception" do
      #     stub_request(:get, "#{url}/1").
      #       to_return(headers: headers, body: response_body)
      #
      #     expect do
      #       subject.find(3)
      #     end.to raise_exception(JSONAPI::Client::RecordNotFound)
      #   end
      # end

    end
  end

  describe "#where" do
    context "when resource is not found" do
      # TODO:
    end

    context "when filtering by a single value" do
      let(:response_body) do
        {
          data:
            {
              id: "1",
              type: "articles",
              attributes:
                {
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
          data:
            [
              {
                id: "1",
                type: "articles",
                attributes:
                  {
                    category: "Programming",
                    title: "Beginner JSONAPI"
                  }
              },
              {
                type: "articles",
                id: "2",
                attributes:
                  {
                    category: "Programming",
                    title: "Advanced JSONAPI"
                  }
              }
            ]
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
          subject.where(category: ["Programming", "Management"]).all
        end

      end

      context "with an array of symbols" do
        it "sends the right request" do
          subject.where(category: [:Programming, :Management]).all
        end
      end
    end


    context "when chaining" do
      # TODO:
    end
  end

  describe "#select" do
    # let(:response_body) do
    #   {
    #     data:
    #       [
    #         {
    #           id: "1",
    #           type: "articles",
    #           attributes:
    #             {
    #               title: "Beginner JSONAPI"
    #             }
    #         },
    #         {
    #           type: "articles",
    #           id: "2",
    #           attributes:
    #             {
    #               title: "Advanced JSONAPI"
    #             }
    #         }
    #       ]
    #   }.to_json
    # end

    # TODO: Is it possible to call the SHOW endpoint with fields? Try it with PEEPS! YES!!!

    context "when selecting a single field" do
      let(:response_body) do
        {
          data:
            {
              id: "1",
              type: "articles",
              attributes:
                {
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
          data:
            {
              id: "1",
              type: "articles",
              attributes:
                {
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


    context "when chaining" do
      context "with #find" do
        let(:response_body) do
          {
            data:
              {
                id: "1",
                type: "articles",
                attributes:
                  {
                    title: "Beginner JSONAPI"
                  }
              }
          }.to_json
        end

        it "sends the right request" do
          stub_request(:get, "#{url}/1").
            with(query: { fields: { "articles" => "title" } }).
            to_return(headers: headers, body: response_body)

          subject.select(:title).find(1)
        end
      end

      context "with #where" do

      end
    end
  end

end
