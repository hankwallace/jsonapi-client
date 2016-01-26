require "spec_helper"
require "jsonapi/client/formatter"

describe JSONAPI::Client::UnderscoredKeyFormatter do
  it "underscores a key" do
    expect(described_class.format("article_id")).to eq("article_id")
  end
end

describe JSONAPI::Client::CamelizedKeyFormatter do
  it "lower camelizes a key" do
    expect(described_class.format("article_id")).to eq("articleId")
  end
end

describe JSONAPI::Client::DasherizedKeyFormatter do
  it "dasherizes a key" do
    expect(described_class.format("article_id")).to eq("article-id")
  end
end

describe JSONAPI::Client::UnderscoredRouteFormatter do
  it "underscores a route" do
    expect(described_class.format("blog_posts")).to eq("blog_posts")
  end
end

describe JSONAPI::Client::CamelizedRouteFormatter do
  it "lower camelizes a route" do
    expect(described_class.format("blog_posts")).to eq("blogPosts")
  end
end

describe JSONAPI::Client::DasherizedRouteFormatter do
  it "dasherizes a route" do
    expect(described_class.format("blog_posts")).to eq("blog-posts")
  end
end
