json.extract! @<%= singular_table_name %> <% model_attributes.each { |attribute| %><%= ", :#{attribute.name}" %><% } %>
