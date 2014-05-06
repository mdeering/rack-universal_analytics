# Encoding: utf-8
require 'rack'
require 'rack/universal-analytics/version'

module Rack
  class UniversalAnalytics

    # @todo Add a debug or staging option that will show all of the code we are going to inject
    #   but have it commented out.

    DEFAULT_OPTIONS = {
      personality: :none,
      adjusted_bounce_rate_timeouts: []
    }.freeze

    def initialize(app, options = {})
      @app     = app
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def call(env)
      # dup the middleware instance for thread safety
      dup._call(env)
    end

    def _call(env)
      @status, @headers, @body = @app.call(env)
      @env = env
      return [@status, @headers, @body] unless opted_in? && html? && requirements_met?
      response = Rack::Response.new([], @status, @headers)

      @body.each { |fragment| response.write inject(fragment) }
      @body.close if @body.respond_to?(:close)

      response.finish
    end

    private

    def personality
      if @options[:personality].respond_to?(:call)
        @options[:personality].call(@env)
      else
        @options[:personality]
      end
    end

    def opted_in?
      [:async, :universal].include? personality
    end

    def universal?
      personality == :universal
    end

    def async?
      personality == :async
    end

    def property_url
      if @options[:property_url].respond_to?(:call)
        @options[:property_url].call(@env)
      else
        @options[:property_url]
      end
    end

    def tracking_id
      if @options[:tracking_id].respond_to?(:call)
        @options[:tracking_id].call(@env)
      else
        @options[:tracking_id]
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
      !!tracking_id && !!property_url
    end

    def script
      return async if async?
      return universal if universal?
    end

    def universal
      <<-UNIVERSAL
      <script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
ga('create', '#{tracking_id}', '#{property_url}');
ga('send', 'pageview');
</script>
      UNIVERSAL
    end

    def async
      async_script = ["<script type=\"text/javascript\">var _gaq = _gaq || [];_gaq.push(['_setAccount', '#{tracking_id}']);"]

      if @env[:custom_vars]
        @env[:custom_vars].each do |var|
          async_script << "_gaq.push(['_setCustomVar', #{var[:slot]}, '#{var[:name]}', '#{var[:value]}', #{var[:scope] || 'undefined'}]);"
        end
      end

      if @env[:tracking_events]
        @env[:tracking_events].each do |var|
          label = var[:label] ? "'#{var[:label]}'" : 'undefined'
          async_script << "_gaq.push(['_trackEvent', '#{var[:category]}', '#{var[:action]}', #{label}, #{var[:value] || 'undefined'}, #{var[:noninteraction] || 'undefined'}]);"
        end
      end

      async_script << "_gaq.push(['_setDomainName', '#{property_url}']);"

      @static_async_components ||= static_async_components
      async_script << @static_async_components
      async_script.join
    end

    # as all of these are based on initialize-time options
    # we don't need to rebuild this part of the script on a per-response basis
    def static_async_components
      static_components = []
      static_components << "_gaq.push(['_setSiteSpeedSampleRate', #{@options[:site_speed_sample_rate].to_i}]);" if @options[:site_speed_sample_rate]

      @options[:adjusted_bounce_rate_timeouts].each do |timeout|
        static_components << %Q|setTimeout("_gaq.push(['_trackEvent', '#{timeout}_seconds', 'read'])",#{timeout * 1000});|
      end

      static_components << <<-ASYNC
_gaq.push(['_trackPageview']);
(function() {
var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
ga.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'stats.g.doubleclick.net/dc.js';
var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();
</script>
      ASYNC

      static_components.join
    end

  end
end
