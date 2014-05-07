# Encoding: utf-8

module Rack
  class UniversalAnalytics

    # Symantic Versioning http://semver.org
    module Version

      MAJOR = 0
      MINOR = 2
      PATCH = 0
      BUILD = ''

      # Returns the current Symantic Version as string.
      #
      # @return [String] current semantic_version of the rack-universal-analytics gem.
      #
      # @example
      #   puts Rack::UniversalAnalytics::Version # => '0.0.1'
      def self.to_s
        [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
      end

    end
  end
end
