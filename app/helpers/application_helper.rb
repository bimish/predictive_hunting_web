module ApplicationHelper

	include DataDomains

	class AppFormBuilder < ActionView::Helpers::FormBuilder

		def coordinates_field(method, options = {})
			options[:readonly] = 'true'
			options[:value] = @object.send(method)
			@template.text_field(@object_name, method, objectify_options(options))
		end

	end

end
