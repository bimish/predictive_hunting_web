<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ComponentController

  include <%= controller_class_name %>ControllerExtensions

  # GET <%= route_url %>
  def index
    @<%= plural_table_name %> ||= <%= orm_class.all(class_name) %>
  end

  # GET <%= route_url %>/1
  def show
  end

  # GET <%= route_url %>/new
  def new
  end

  # GET <%= route_url %>/1/edit
  def edit
  end

  # POST <%= route_url %>
  def create
    respond_to do |format|
      if @<%= orm_instance.save %>
        format.html { redirect_to @<%= singular_table_name %>, notice: <%= "'#{human_name} was successfully created.'" %> }
        format.json { render action: 'show', status: :created, location: @<%= singular_table_name %> }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @<%= singular_table_name %>.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT <%= route_url %>/1
  def update
    respond_to do |format|
      if @<%= orm_instance.update("update_params") %>
        format.html { redirect_to @<%= singular_table_name %>, notice: '<%= human_name %> was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @<%= singular_table_name %>.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    @<%= orm_instance.destroy %>
    respond_to do |format|
      format.html { redirect_to <%= index_helper %>_url, notice: <%= "'#{human_name} was successfully destroyed.'" %> }
      format.json { head :no_content }
      format.js
    end
  end

  private
    def get_component
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    def new_component(params = nil)
      @<%= singular_table_name %> = <%= orm_class.build(class_name, "params") %>
    end

    def update_params
      <%- if model_attributes.empty? -%>
      params[:<%= singular_table_name %>]
      <%- else -%>
      params.require(:<%= singular_table_name %>).permit(<%= model.updateable_attribute_names.map { |attribute_name| ":#{attribute_name}" }.join(', ') %>)
      <%- end -%>
    end

    def create_params
      <%- if model_attributes.empty? -%>
      params[:<%= singular_table_name %>]
      <%- else -%>
      params.require(:<%= singular_table_name %>).permit(<%= model.assignable_attribute_names.map { |attribute_name| ":#{attribute_name}" }.join(', ') %>)
      <%- end -%>
    end

end
<% end -%>
