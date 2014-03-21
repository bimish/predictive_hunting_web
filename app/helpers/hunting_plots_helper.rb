module HuntingPlotsHelper

	class MyFormBuilder < ActionView::Helpers::FormBuilder

		def coordinates_label(label, *args)
			@template.label :label, "#{label} (latitude,longitude)"
		end

		def coordinates_field(label, *args)

			@template.text_field(:label, args) +
			@template.text_field(:label, args)

		end

	end

end
