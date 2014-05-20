require File.expand_path('../route', __FILE__)

module RestlessRouter
  class Routes
    include Enumerable

    # Error Definitions
    InvalidRouteError  = Class.new(StandardError)
    ExistingRouteError = Class.new(StandardError)
    RouteNotFoundError = Class.new(StandardError)

    # Creates a new instance of a Route collection. This allows
    # us to keep all definitions in a single object and then
    # later retrieve them by their link relationship name.
    #
    # @example
    #   routes = RestlessRouter::Routers.new
    #   routes.add_route(RestlessRouter::Route.new('home', 'https://example.com/home')
    #
    #   routes.route_for('home').url_for
    #   # => 'https://example.com/home'
    #
    def initialize
      @routes = []
    end

    # Define each for use with Enumerable
    #
    def each(&block)
      @routes.each(&block)
    end

    # Add a new route to the Routes collection
    #
    # @return [Array] Routes collection
    def add_route(route)
      raise InvalidRouteError.new('Route must respond to #url_for') unless valid_route?(route)
      @routes << route unless route_exists?(route)
    end
    alias :<< :add_route

    # Raise an exception if the route is invalid or already exists
    #
    def add_route!(route)
      # Raise exception if the route is existing, too
      raise InvalidRouteError.new('Route must respond to #url_for') unless valid_route?(route)
      raise ExistingRouteError.new(("Route already exists for %s" % [route.name])) if route_exists?(route)

      @routes << route
    end

    # Retrieve a route by it's link relationship name
    #
    # @return [Route, nil] Instance of the route by name or nil
    def route_for(name)
      name = name.to_s
      @routes.select { |entry| entry.name == name }.first
    end

    # Raise an exception of the route's not found
    #
    #
    def route_for!(name)
      route = route_for(name)
      raise RouteNotFoundError.new(("Route not found for %s" % [name])) if route.nil?
      route
    end

    # Returns the collection of Route definitions
    #
    # @return [Array] Routes
    def routes
      @routes
    end

    # Query method to check if any routes have been defined.
    #
    # @return [Boolean] True if there are definitions in the collection
    def routes?
      @routes.any?
    end

    private
    # Query method to see if the specified route already exists.
    #
    # @return [Boolean] True if we already have an existing route
    def route_exists?(route)
      !!self.route_for(route.name)
    end

    # Query method to see if the route definition being added is valid.
    #
    # It must respond to:
    #
    # * `name`
    # * `url_for`
    #
    # @return [Boolean] True if the route definition is valid
    def valid_route?(route)
      route.respond_to?(:url_for) && route.respond_to?(:name)
    end
  end
end
