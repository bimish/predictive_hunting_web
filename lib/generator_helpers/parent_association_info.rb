require File.dirname(__FILE__) + '/model_info'

module GeneratorHelpers

  class ParentAssociationInfo

    attr_reader   :name
    attr_reader   :column_name
    attr_reader   :class_name

    def initialize(association)
      @name = association.name

      if (association.options.nil? || association.options[:foreign_key].nil?)
        @column_name = "#{association.name}_id"
      else
        @column_name = association.options[:foreign_key]
      end

      if (association.options.nil? || association.options[:class_name].nil?)
        @class_name = association.name.to_s.camelize
      else
        @class_name = association.options[:class_name]
      end

    end

    def referenced_model
      @model_info ||= ModelInfo.new(@class_name)
    end

  end

end
