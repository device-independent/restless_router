require 'addressable/template'

module RestlessRouter
  class Route
    include Comparable

    # Create a new Route that can be used
    # to issue requests against.
    #
    # @example
    #   # With a fully qualified URI
    #   route = RestlessRouter::Route.new('home', 'http://example.com')
    #
    #   route.name
    #   # => 'home'
    #
    #   route.url_for
    #   # => 'http://example.com'
    #
    #   # With a templated route
    #   route = RestlessRouter::Route.new('search', 'http://example.com/search{?q}', templated: true)
    #   
    #   route.name
    #   # => 'search'
    #
    #   route.url_for(q: 'search-term')
    #   # => 'http://example.com/search?q=search-term'
    #
    def initialize(name, path, options={})
      @name = name
      @path = path

      @options = default_options.merge(options)
    end

    # Define the spaceship operator for use with Comparable
    #
    def <=>(other)
      self.name <=> other.name
    end

    # Return the name of the Route. This is either
    # the IANA or custom link relationship.
    #
    # @return [String] Name of the route
    def name
      @name
    end

    # Returns the URL for the route. If it's templated,
    # then we utilize the provided options hash to expand
    # the route. Otherwise we return the `path`
    #
    # @return [String] The templated or base URI
    def url_for(options={})
      if templated?
        template = Addressable::Template.new(base_path)
        template = template.expand(options)
        template.to_s
      else
        base_path
      end
    end

    private
    # Provide a set of default options. Currently
    # this is used to set `templated` to false.
    def default_options
      {
        :templated => false
      }
    end

    # Query method to see if the URI path provided
    # is templated
    #
    # @return [Boolean] True if the path is templated
    def templated?
      @options.fetch(:templated)
    end

    # The base path provided for the route
    #
    # @return [String] The base path
    def base_path
      @path
    end
  end
end
