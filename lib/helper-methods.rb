module HelperMethods

protected

	def push_custom_variable(slot, name, value, scope = nil)
		self.env[:custom_vars] ||= []
		self.env[:custom_vars] << {slot: slot, name: name, value: value, scope: scope}
	end

end