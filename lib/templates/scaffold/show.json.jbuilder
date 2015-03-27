json.extract! @<%= singular_table_name %><% model.readable_attribute_names.each { |attribute_name| %><%= ", :#{attribute_name}" %><% } %>
