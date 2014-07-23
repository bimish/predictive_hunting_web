json.extract! @<%= singular_table_name %>, :id <% model_attributes.each { |attribute| %><%= ", :#{attribute.name}" %><% } %>
