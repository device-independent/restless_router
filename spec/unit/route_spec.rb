require File.expand_path('../../../lib/restless_router/route', __FILE__)

describe RestlessRouter::Route do
  let(:name) { 'home' }
  let(:path) { 'http://www.example.com' }
  let(:options) { {} }

  subject { described_class.new(name, path, options) }

  # TODO: Validations on empty `name` or `path`

  context "with URI" do
    it "returns the #name" do
      expect(subject.name).to eq('home')
    end

    it "returns the #path" do
      expect(subject.path).to eq('http://www.example.com')
    end

    it "returns the #url_for" do
      expect(subject.url_for).to eq('http://www.example.com')
    end
  end

  context "with URI Template" do
    let(:name) { 'search' }
    let(:path) { 'http://www.example.com/search{?q}' }
    let(:options) { { templated: true } }

    it "returns the expanded #url_for" do
      expect(subject.url_for(q: 'search-term')).to eq('http://www.example.com/search?q=search-term')
    end

    it "returns the raw #path" do
      expect(subject.path).to eq('http://www.example.com/search{?q}')
    end

    it "returns the expanded #url_for with no expansions" do
      expect(subject.url_for).to eq('http://www.example.com/search')
    end
  end
end
