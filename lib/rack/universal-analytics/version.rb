# Encoding: utf-8

module Rack
  module UniversalAnalytics

    # Symantic Versioning http://semver.org
    module Version

      MAJOR = 0
      MINOR = 0
      PATCH = 1
      BUILD = 'alpha'

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
