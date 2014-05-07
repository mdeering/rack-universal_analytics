module HelperMethods

  # pushes a custom variable to google. see: 
  # https://developers.google.com/analytics/devguides/collection/gajs/methods/gaJSApiBasicConfiguration?csw=1#_gat.GA_Tracker_._setCustomVar
  #
  # @param slot [Integer] the slot for the custom variable. 1-5 inclusive
  # @param name [String] the name of the custom variable
  # @param value [String] the value of the custom variable
  # @param scope [Integer] optional, 1 = visitor-level, 2 = session-level, 3 = page-level
  def push_analytics_variable(slot, name, value, scope = nil)
    env[:custom_vars] ||= []
    env[:custom_vars] << { slot: slot, name: name, value: value, scope: scope }
  end

  # sends a custom analytics event to google. see:
  # https://developers.google.com/analytics/devguides/collection/gajs/methods/gaJSApiEventTracking#_gat.GA_EventTracker_._trackEvent
  #
  # @param category [String] the event category name
  # @param action [String] the action name for the event
  # @param label [String] optional, a string to label the event with
  # @param value [Integer] optional, an arbitrary value for the event
  # @param noninteraction [Bool] optional, when true the event does not impact bounce rate calculations
  def track_analytics_event(category, action, label = nil, value = nil, noninteraction = false)
    env[:tracking_events] ||= []
    env[:tracking_events] << {
      category: category,
      action: action,
      label: label,
      value: value,
      noninteraction: noninteraction
   }
  end

end
