json.array!(@<%= plural_table_name %>) do |<%= singular_table_name %>|
  json.extract! <%= singular_table_name %><% model.readable_attribute_names.each { |attribute_name| %><%= ", :#{attribute_name}" %><% } %>
  json.url <%= singular_table_name %>_url(<%= singular_table_name %>, format: :json)
end
