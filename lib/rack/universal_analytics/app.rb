# Encoding: utf-8
require 'rack/universal_analytics/version'

module Rack
  module UniversalAnalytics

    # This guy here is our Rack application that is going to do the majority of the work around
    # here.
    #
    # @todo Add a debug or staging option that will show all of the code we are going to inject
    #   but have it commented out.
    class App

      DEFAULT_OPTIONS = {}.freeze

      def initialize(app, options = {})
        @app     = app
        @options = DEFAULT_OPTIONS.merge(options)
      end

      def call(env)
        # dup the middleware instance for thread safety
        dup._call(env)
      end

      def _call(env)
        @env = env
        @status, @headers, @body = @app.call(@env)
        return [@status, @headers, @body] unless html? && requirements_met?
        response = Rack::Response.new([], @status, @headers)

        @body.each { |fragment| response.write inject(fragment) }
        @body.close if @body.respond_to?(:close)

        response.finish
      end

      private

      def tracker_id
        @tracker_id ||= if @options[:tracker_id].respond_to?(:call)
                          @options[:tracker_id].call(@env)
                        else
                          @options[:tracker_id]
                        end
      end

      def html?
        # NOTE: Would also catch xhtml but I'm not concerned with that right now.
        !!(@headers['Content-Type'] =~ /html/i)
      end

      def inject(fragment)
        return fragment unless /<\/head>/i =~ fragment
        fragment.gsub!(/(<\/head>)/i, "#{script}\\1")
      end

      def requirements_met?
        !!tracker_id
      end

      def script
        "<script type='text/javascript'>alert('#{tracker_id});</script>"
      end

    end

  end
end
