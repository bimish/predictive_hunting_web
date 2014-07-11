require File.dirname(__FILE__) + '/../../generator_helpers/model_info'

require 'rails/generators/resource_helpers'

module Rails
  module Generators
    class ControllerGenerator < NamedBase # :nodoc:

      include ResourceHelpers
      include GeneratorHelpers

      argument :actions, type: :array, default: [], banner: "action action"
      #class_option :skip_routes, type: :boolean, desc: "Dont' add routes to config/routes.rb."
      class_option :orm, banner: "NAME", type: :string, required: true, desc: "ORM to generate the controller for"

      check_class_collision suffix: "Controller"

      #def create_controller_files
      #  say "using custom controller generator - #{model_attributes.size}"
      #  template '../scaffold_controller/controller.rb', File.join('app/controllers', class_path, "#{file_name}_controller.rb")
      #end

      def create_controller_files

        #say "orm_class.nil? = #{orm_class.nil?}"

        template '../scaffold_controller/controller.rb', File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")

        extensions_module_path = File.join('app/controllers/concerns', controller_class_path, "#{controller_file_name}_controller_extensions.rb")
        if File.file?(extensions_module_path)
          say "#{extensions_module_path} already exists, skipping"
        else
          template '../scaffold_controller/controller_extensions.rb', extensions_module_path
        end
      end

      def add_routes
        unless options[:skip_routes]
          actions.reverse.each do |action|
            route generate_routing_code(action)
          end
        end
      end

      hook_for :template_engine, :test_framework, :helper, :assets

      def model
        @model ||= ModelInfo.new(class_name.singularize)
      end

      def model_attributes
        return self.model.attributes
      end

      private

        # This method creates nested route entry for namespaced resources.
        # For eg. rails g controller foo/bar/baz index
        # Will generate -
        # namespace :foo do
        #   namespace :bar do
        #     get 'baz/index'
        #   end
        # end
        # def generate_routing_code(action)
        #   depth = regular_class_path.length
        #   # Create 'namespace' ladder
        #   # namespace :foo do
        #   #   namespace :bar do
        #   namespace_ladder = regular_class_path.each_with_index.map do |ns, i|
        #     indent("namespace :#{ns} do\n", i * 2)
        #   end.join

        #   # Create route
        #   #     get 'baz/index'
        #   route = indent(%{get '#{file_name}/#{action}'\n}, depth * 2)

        #   # Create `end` ladder
        #   #   end
        #   # end
        #   end_ladder = (1..depth).reverse_each.map do |i|
        #     indent("end\n", i * 2)
        #   end.join

        #   # Combine the 3 parts to generate complete route entry
        #   namespace_ladder + route + end_ladder
        # end
    end
  end
end
