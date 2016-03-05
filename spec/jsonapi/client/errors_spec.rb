require "spec_helper"

describe JSONAPI::Client::Resource, "errors" do
  subject { Article }

  let(:url) { "#{subject.url}/articles" }
  let(:headers) do
    { content_type: "application/vnd.api+json" }
  end

  it "handles a connection error" do
    stub_request(:get, url).
      to_raise(Faraday::ConnectionFailed)

    expect do
      subject.all
    end.to raise_exception(JSONAPI::Client::ConnectionError)
  end

  it "handles a timeout error" do
    stub_request(:get, url).
      to_raise(Faraday::TimeoutError)

    expect do
      subject.all
    end.to raise_exception(JSONAPI::Client::ConnectionError)
  end

  it "handles a not authorized error" do
    stub_request(:get, url).
      to_return(headers: headers, status: 401, body: {}.to_json)

    expect do
      subject.all
    end.to raise_exception(JSONAPI::Client::NotAuthorized)
  end

  it "handles an access denied error" do
    stub_request(:get, url).
      to_return(headers: headers, status: 403, body: {}.to_json)

    expect do
      subject.all
    end.to raise_exception(JSONAPI::Client::AccessDenied)
  end

  it "handles a not found error" do
    stub_request(:get, url).
      to_return(headers: headers, status: 404, body: {}.to_json)

    expect do
      subject.all
    end.to raise_exception(JSONAPI::Client::NotFound)
  end

  it "handles an unprocessable entity error" do
    stub_request(:get, url).
      to_return(headers: headers, status: 422, body: {}.to_json)

    expect do
      subject.all
    end.to raise_exception(JSONAPI::Client::UnprocessableEntity)
  end

  it "handles a bad request error" do
    stub_request(:get, url).
      to_return(headers: headers, status: 400, body: {}.to_json)

    expect do
      subject.all
    end.to raise_exception(JSONAPI::Client::BadRequest)
  end

  it "handles a server error" do
    stub_request(:get, url).
      to_return(headers: headers, status: 500, body: {}.to_json)

    expect do
      subject.all
    end.to raise_exception(JSONAPI::Client::ServerError)
  end

  it "handles an unexpected status" do
    stub_request(:get, url).
      to_return(headers: headers, status: 731, body: {}.to_json)

    expect do
      subject.all
    end.to raise_exception(JSONAPI::Client::UnexpectedStatus)
  end
end
