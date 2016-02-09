require "spec_helper"

describe JSONAPI::Client::Resource, "query formatting" do
  subject { ExpenseReport }

  let(:url) { "#{subject.url}/expense-reports" }
  let(:headers) do
    { content_type: "application/vnd.api+json" }
  end

  before(:each) do
    # Reset formatters
    subject.instance_variable_set(:@route_format, nil)
    subject.instance_variable_set(:@route_formatter, nil)
    subject.instance_variable_set(:@key_format, nil)
    subject.instance_variable_set(:@key_formatter, nil)
  end

  describe "route formatting" do
    let(:approved_on) { Time.now.utc.iso8601 }

    context "when dasherized" do
      let(:url) { "#{subject.url}/expense-reports" }

      before(:each) do
        ExpenseReport.route_format = :dasherized_route
      end

      it "sends the right request" do
        stub_request(:get, "#{url}").
          with(query: { filter: { "approved-on": approved_on } })

        subject.where(approved_on: approved_on).all
      end
    end

    context "when underscored" do
      let(:url) { "#{subject.url}/expense_reports" }

      before(:each) do
        ExpenseReport.route_format = :underscored_route
      end

      it "sends the right request" do
        stub_request(:get, "#{url}").
          with(query: { filter: { approved_on: approved_on } })

        subject.where(approved_on: approved_on).all
      end
    end
  end

  describe "key formatting" do
    let(:approved_on) { Time.now.utc.iso8601 }

    context "when camelized" do
      let(:response_body) do
        {
          data: [{
            type: "expense-reports",
            id: "1",
            attributes: {
              category: "R&D",
              "approvedOn": approved_on
            }
          }, {
            id: "2",
            type: "expense-reports",
            attributes: {
              category: "Sales",
              "approvedOn": approved_on
            }
          }]
        }.to_json
      end

      before(:each) do
        ExpenseReport.key_format = :camelized_key
      end

      it "sends the right request" do
        # TODO: Using a request w/ body
      end

      it "processes the response" do
        stub_request(:get, "#{url}").
          to_return(headers: headers, body: response_body)

        results = subject.all

        expect(results).to be_a(Array)
        expect(results.length).to eq(2)
        expect(results[0].approved_on).to eq(approved_on)
        expect(results[1].approved_on).to eq(approved_on)
      end
    end

    context "when dasherized" do
      let(:response_body) do
        {
          data: [{
            type: "expense-reports",
            id: "1",
            attributes: {
              category: "R&D",
              "approved-on": approved_on
            }
          }, {
            id: "2",
            type: "expense-reports",
            attributes: {
              category: "Sales",
              "approved-on": approved_on
            }
          }]
        }.to_json
      end

      before(:each) do
        ExpenseReport.key_format = :dasherized_key
      end

      it "sends the right request" do
        # TODO: Using a request w/ body
      end

      it "processes the response" do
        stub_request(:get, "#{url}").
          to_return(headers: headers, body: response_body)

        results = subject.all

        expect(results).to be_a(Array)
        expect(results.length).to eq(2)
        expect(results[0].approved_on).to eq(approved_on)
        expect(results[1].approved_on).to eq(approved_on)
      end
    end

    context "when underscored" do
      let(:response_body) do
        {
          data: [{
            type: "expense_reports",
            id: "1",
            attributes: {
              category: "R&D",
              approved_on: approved_on
            }
          }, {
            id: "2",
            type: "expense_reports",
            attributes: {
              category: "R&D",
              approved_on: approved_on
            }
          }]
        }.to_json
      end

      before(:each) do
        ExpenseReport.key_format = :underscored_key
      end

      it "sends the right request" do
        # TODO: Using a request w/ body
      end

      it "processes the response" do
        stub_request(:get, "#{url}").
          to_return(headers: headers, body: response_body)

        results = subject.all

        expect(results).to be_a(Array)
        expect(results.length).to eq(2)
        expect(results[0].approved_on).to eq(approved_on)
        expect(results[1].approved_on).to eq(approved_on)
      end
    end
  end
end
