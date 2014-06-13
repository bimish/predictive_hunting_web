<%-
module_namespacing do
-%>
module Generated
  module <%= class_name %>Helper
<%-
  model.attributes.reject(&:password_digest?).each do |attribute|
    if attribute.reference? || attribute.has_value_list?
      item_name = attribute.reference? ? attribute.reference.name : attribute.name
-%>
    def get_<%= item_name %>_list_items()

    end
    def get_<%= item_name %>_description(<%= table_name.singularize %>)
<%-
    if (attribute.reference? && attribute.reference_model.new.respond_to?('get_display_name'))
-%>
      return <%= table_name.singularize %>.<%= attribute.reference.name%>.get_display_name
<%-
    else
-%>
      raise NotImplementedError
<%-
    end
-%>
    end
<%-
    end
  end
-%>
  end
end
<%-
end
-%>
