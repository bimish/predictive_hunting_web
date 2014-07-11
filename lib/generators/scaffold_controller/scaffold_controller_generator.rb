require File.dirname(__FILE__) + '/../../generator_helpers/model_info'

require 'rails/generators/resource_helpers'

module Rails
  module Generators
    class ScaffoldControllerGenerator < NamedBase # :nodoc:

      include ResourceHelpers
      include GeneratorHelpers

      check_class_collision suffix: "Controller"

      class_option :orm, banner: "NAME", type: :string, required: true, desc: "ORM to generate the controller for"

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def create_controller_files

        template "controller.rb", File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")

        extensions_module_path = File.join('app/controllers/concerns', controller_class_path, "#{controller_file_name}_controller_extensions.rb")
        if File.file?(extensions_module_path)
          say "#{extensions_module_path} already exists, skipping"
        else
          template 'controller_extensions.rb', extensions_module_path
        end
      end

      hook_for :template_engine, :test_framework, as: :scaffold

      # Invoke the helper using the controller name (pluralized)
      hook_for :helper, as: :scaffold do |invoked|
        invoke invoked, [ controller_name ]
      end

      def model
        @model ||= ModelInfo.new(class_name.singularize)
      end

      def model_attributes
        return self.model.attributes
      end

    end
  end
end
