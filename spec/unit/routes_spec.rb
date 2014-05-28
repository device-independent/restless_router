require 'ostruct'
require File.expand_path('../../../lib/restless_router/routes', __FILE__)

describe RestlessRouter::Routes do
  let(:home_route) { RestlessRouter::Route.new('home', 'https://example.com/home') }
  let(:search_route) { RestlessRouter::Route.new('search', 'https://example.com/search{?q}', templated: true) }
  let(:route_definitions) { [home_route, search_route] }

  subject { described_class.new }

  before(:each) do
    route_definitions.each { |route| subject.add_route(route) }
  end

  context "Route adding DSL" do
    it "allows you to add a route" do
      routes = described_class.new do |route|
        route.add_route(home_route)
        route.add_route(search_route)
      end

      expect(routes.count).to eql(2)
    end
  end

  context "without routes" do
    let(:route_definitions) { [] }

    it "returns false for #any?" do
      expect(subject.any?).to be_false
    end

    it "returns 0 for the count" do
      expect(subject.count).to eq(0)
    end

    context "retrieving a route definition" do
      describe "#route_for" do
        it "returns nil when searching for 'home'" do
          expect(subject.route_for('home')).to be_nil
        end
      end

      describe "#route_for!" do
        it "raises an exception with searching for 'home'" do
          lambda { subject.route_for!('home') }.should raise_error(RestlessRouter::Routes::RouteNotFoundError)
        end
      end
    end
  end

  context "with routes" do
    it "returns true for #any?" do
      expect(subject.any?).to be_true
    end

    it "returns 2 for the count" do
      expect(subject.count).to eq(2)
    end


    context "retrieving a route definition" do
      describe "#route_for" do
        it "returns the route specified for 'home'" do
          expect(subject.route_for('home')).to eq(home_route)
        end

        it "returns the route specified for 'search'" do
          expect(subject.route_for('search')).to eq(search_route)
        end

        it "returns nil when route specified for 'not-defined'" do
          expect(subject.route_for('not-defined')).to be_nil
        end
      end

      describe "#route_for!" do
        it "raises an exception with searching for 'not-defined'" do
          lambda { subject.route_for!('not-defined') }.should raise_error(RestlessRouter::Routes::RouteNotFoundError)
        end
      end
    end
  end

  context "ensure uniqueness by link relationship name" do
    let(:route_definitions) { [] }

    describe "#add_route" do
      it "does not add a route with the same name" do
        subject.add_route(home_route)
        subject.add_route(home_route)
        expect(subject.count).to eq(1)
      end
    end

    describe "#add_route!" do
      it "raises an exception if route is specified with the same name" do
        subject.add_route!(home_route)

        lambda { subject.add_route!(home_route) }.should raise_error(RestlessRouter::Routes::ExistingRouteError)
      end
    end
  end

  context "adding a new route definition" do
    it "raises an exception if nil is added" do
      lambda { subject.add_route(nil) }.should raise_error(RestlessRouter::Routes::InvalidRouteError)
    end

    it "raises an error if route definition does not respond to #name" do
      route_definition = OpenStruct.new(url_for: 'http://example.com')
      lambda { subject.add_route(route_definition) }.should raise_error(RestlessRouter::Routes::InvalidRouteError)
    end

    it "raises an error if route definition does not respond to #url_for" do
      route_definition = OpenStruct.new(name: 'home')
      lambda { subject.add_route(route_definition) }.should raise_error(RestlessRouter::Routes::InvalidRouteError)
    end

    it "pushes the valid route onto the stack" do
      route_definition = OpenStruct.new(name: 'custom-name', url_for: 'http://example.com')
      subject.add_route(route_definition)

      expect(subject).to include(route_definition)
    end
  end
end
