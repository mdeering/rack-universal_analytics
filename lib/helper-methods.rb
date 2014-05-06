module HelperMethods

  protected

  def push_custom_variable(slot, name, value, scope = nil)
    env[:custom_vars] ||= []
    env[:custom_vars] << { slot: slot, name: name, value: value, scope: scope }
  end

  def track_analytics_event(category, action, label = nil, value = nil, noninteraction = nil)
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
