<%- module_namespacing do -%>
module <%= class_name %>Helper
  include Generated::<%= class_name %>Helper
end
<% end -%>
