require 'rails/generators/named_base'
require 'rails/generators/resource_helpers'
require File.dirname(__FILE__) + '/../../../generator_helpers/model_info'
require File.dirname(__FILE__) + '/../../../generator_helpers/template_helpers'

module All # :nodoc:

  module Generators # :nodoc:

    class ScaffoldGenerator < Rails::Generators::NamedBase # :nodoc:

      include Rails::Generators::ResourceHelpers
      include GeneratorHelpers
      include TemplateHelpers

      def initialize(args, *options)
        super
        @model = ModelInfo.new(@name)
      end

      source_root File.join(Rails.root, 'lib', 'templates', 'scaffold', File::SEPARATOR)

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def model
        return @model
      end

      def model_attributes
        return @model.attributes
      end

      def create_root_folder
        empty_directory File.join("app/views", controller_file_path)
      end

      def copy_view_files
        available_views.each do |view|
          template view, File.join("app/views", controller_file_path, view)
        end
      end

    protected
      def available_views
        # use all template files contained in source_root ie 'lib/templates/scaffold/**/*'
        base = self.class.source_root
        base_len = base.length
        Dir[File.join(base, '**', '*')].select { |f| File.file?(f) }.map{|f| f[base_len..-1]}
      end

    end

  end

end
