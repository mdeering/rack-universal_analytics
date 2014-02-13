# Encoding: utf-8
require "rack/universal_analytics/version"

module Rack
  module UniversalAnalytics
    class App

     def initialize(app, options = {})
       @app = app
     end

     # dup the middleware instance for thread safety
      def call(env)
        dup._call(env)
      end

      def _call(env)
        @status, @headers, @body = @app.call(env)
        @body.gsub!(/OK/, 'Rack::UniversalAnalytics was here!') if html?
        [@status, @headers, @body]
      end

      private

      def html?
        @headers['Content-Type'] =~ /html/
      end

    end
  end
end
