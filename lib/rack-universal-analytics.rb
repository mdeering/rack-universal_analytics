require 'rack/universal-analytics'
require 'helper-methods'

# helper methods for injecting custom variables
ActionController::Base.send(:include, HelperMethods) if defined?(ActionController::Base)
