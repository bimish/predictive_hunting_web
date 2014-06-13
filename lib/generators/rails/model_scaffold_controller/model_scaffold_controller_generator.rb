require File.dirname(__FILE__) + '/../../../generator_helpers/model_info'

module Rails
  module Generators
    class ModelScaffoldControllerGenerator < Rails::Generators::ScaffoldControllerGenerator

      include GeneratorHelpers

      def model
        @model ||= ModelInfo.new(class_name.singularize)
      end

      def model_attributes
        return self.model.attributes
      end

    end
  end
end
