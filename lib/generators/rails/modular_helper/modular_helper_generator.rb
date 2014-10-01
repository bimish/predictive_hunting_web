require 'rails/generators/named_base'
require 'rails/generators/resource_helpers'
require File.dirname(__FILE__) + '/../../../generator_helpers/model_info'

module Rails
  module Generators
    class ModularHelperGenerator < Rails::Generators::NamedBase # :nodoc:

      check_class_collision suffix: "Helper"

      #include Rails::Generators::ResourceHelpers
      include GeneratorHelpers

      def model
        @model ||= ModelInfo.new(class_name.singularize)
      end

      def create_helper_files
        helper_path = File.join('app/helpers', class_path, "#{file_name}_helper.rb")
        if File.file?(helper_path)
          say "#{helper_path} already exists, skipping"
        else
          template 'helper.rb', File.join('app/helpers', class_path, "#{file_name}_helper.rb")
        end
        #say 'creating generated helper'
        #template 'helper-generated.rb', File.join('app/helpers/generated', class_path, "#{file_name}_helper.rb")
      end

      hook_for :test_framework, as: :helper

    end
  end
end
