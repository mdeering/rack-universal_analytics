# Encoding: utf-8
require 'rack/universal-analytics/version'
require 'rack/universal-analytics/app'

module Rack
  # The more and more that I think about it and start looking through the implementation of the
  # existing rack-google-analytics gem the more I think I'm going to come up with a universal DSL
  # to cover all the versions of the Google urchins scripts.
  module UniversalAnalytics
  end
end
