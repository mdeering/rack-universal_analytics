# Rack::UniversalAnalytics

Rack Middleware for injecting Google Analytics tracking code (either the new universal analytics version, or the legacy asynchronous version).

## Usage

#### Gemfile

```ruby
gem 'rack-universal-analytics'
```

#### Sinatra

```ruby
## app.rb
use Rack::UniversalAnalytics, :tracking_id => 'UA-xxxxxx-x'
```

#### Rails 3.X and Rails 4.X

```ruby
## config/application.rb:
config.middleware.use Rack::UniversalAnalytics, :tracking_id => 'UA-xxxxxx-x'
```

### Options

* `:tracking_id` (String, lambda) — The Google Analytics tracking ID for your account. If not set, this middleware is a no-op
* `:property_url` (String, lambda) — Domain for GATC cookies. If not set and personality is set to :universal, this middleware is a no-op
* `:personality` (Symbol, lambda) — analytics personality to use. One of :async, :universal, :none (default). When not set to :universal or :async, this rack middleware is a no-op
* `:adjusted_bounce_rate_timeouts` (Array) — An array of times in seconds that the tracker will use to set timeouts for adjusted bounce rate tracking. See analytics.blogspot.ca/2012/07/tracking-adjusted-bounce-rate-in-google.html for details. ex: [15, 30, 45, 60]
* `:site_speed_sample_rate` (Integer) — Defines a new sample set size for Site Speed data collection, see developers.google.com/analytics/devguides/collection/gajs/methods/gaJSApiBasicConfiguration?hl=de#gat.GA_Tracker._setSiteSpeedSampleRate


If you are not sure what's best, go with the defaults, and read here if you should opt-out.

## Event Tracking

In your application controller, you may track an event. For example:

```ruby
track_analytics_event("Newsletter", "Signup")
```

See https://developers.google.com/analytics/devguides/collection/analyticsjs/events

## Custom Variables

In your application controller, you may push arbritrary data. For example:

```ruby
push_analytics_variable(1, "User", "John Doe")
```

## Dynamic Options

You may instead define any of `:tracking_id`, `:personality`, or `:property_url` to a lambda to dynamically vary them on a request-by-request basis

```ruby
config.middleware.use Rack::UniversalAnalytics, 
  tracking_id: ->(env) {
    return env[:site_ga].tracker if env[:site_ga]
  },
  property_url: ->(env) {
    return Website.domain
  },
  personality: ->(env) {
    case env[:foo]
    when :bar then :async
    when :baz then :universal
    end
  }

```

## Thread Safety

This middleware *should* be thread safe. Although my experience in such areas is limited, having taken the advice of those with more experience; I defer the call to a shallow copy of the environment, if this is of consequence to you please review the implementation.


## Contributing

* Fork it
* Create your feature branch (`git checkout -b my-new-feature`)
* Add tests. This is important! It helps me not break your feature unintentionally in the future!
* Commit your changes (`git commit -am 'Add some feature'`)
* Push to the branch (`git push origin my-new-feature`)
* Create new Pull Request


## Copyright
Copyright (c) 2014 Matthew Barnett, Mike Deering, with portions courtesy Lee Hambley's [rack-google-analytics] (https://github.com/kangguru/rack-google-analytics)
See LICENSE for details.
