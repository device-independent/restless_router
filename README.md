# RestlessRouter

[![Build Status](https://travis-ci.org/nateklaiber/restless_router.svg?branch=v0.0.1)](https://travis-ci.org/nateklaiber/restless_router)

This helps fill the gap where web services only provide their routing
via external documentation. In order to prevent URL building scattered
throughout your client, you can define the routes up-front via fully
qualified URIs or [URI Templates](http://tools.ietf.org/html/rfc6570).

You can then reference a URL by looking it up by it's _link
relationship_.


## Installation

Add this line to your application's Gemfile:

    gem 'restless_router'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install restless_router

## Usage

The first step is to **define the possible routes that a service may
utilize**. In most cases they can be found in their online documentation
of the service.

```ruby
require 'restless_router'

routes = RestlessRouter::Routes.new

# Add a fully qualified URI
routes.add_route(RestlessRouter::Route.new('directory', 'https://example.com/directory')

# Add a URI Templated
routes.add_route(RestlessRouter::Route.new('http://example.com/rels/user-detail', 'https://example.com/users/{id}', templated: true)
```

> You may also use the `<<` operator to add routes to the collection.

Once the routes have been defined, you may **lookup the routes** by their
[IANA Link
Relationship](http://www.iana.org/assignments/link-relations/link-relations.xhtml)
or _Custom Link Relationships_.

```ruby

# Look up the Directory route
directory_route = routes.route_for('directory')
directory_url   = directory_route.url_for
# => 'https://example.com/directory'

# Look up the User Detail route
user_detail_route = routes.route_for('http://example.com/rels/user-detail')
user_defail_url   = user_detail_route.url_for(id: '1234')
# => 'https://example.com/users/1234'
```

This can then be utilized as you see fit with your `HTTP` adapter.

```ruby
require 'faraday'
require 'restless_router'

# Routes are defined in the core application
class Application
  def self.routes
    # Include route definitions here
  end
end

# We can then reference the routes
directory_route = Application.routes.route_for('directory')
directory_url   = directory_route.url_for

# And make a request
directory_request = Faraday.get(directory_url)
```

## Approach

* There is a `Routes` collection that holds the route definitions.
* There is a `Route` object that holds the details of the route definition.
* There are mechanisms to _find_ the route, and _expand_ the route if necessary.

Some APIs may provide hypermedia envelopes and you should use those where
available. 

## Contributing

1. Fork it ( http://github.com/<my-github-username>/restless_router/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
