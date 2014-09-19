module TemplateHelpers

  def get_attribute_display_value_string(object_var_name, attribute)

    if (attribute.reference?)
      "(#{object_var_name}.#{attribute.name}.nil?) ? nil : #{object_var_name}.#{attribute.reference.name}.get_display_name"
    elsif attribute.is_enum?
      "EnumsHelper::#{@model.name}Enums::get_#{attribute.name}_description(#{object_var_name}.#{attribute.name})"
    elsif attribute.has_value_list?
      "@view_data.get_#{attribute.name}_description(#{object_var_name}.#{attribute.name})"
    elsif attribute.type == :datetime
      "date_time_to_s(#{object_var_name}.#{attribute.name})"
    else
      "#{object_var_name}.#{attribute.name}"
    end

  end

end
