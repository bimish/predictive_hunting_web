require File.dirname(__FILE__) + '/attribute_info'
require File.dirname(__FILE__) + '/parent_association_info'

module GeneratorHelpers

  class ModelInfo

    attr_reader   :model
    attr_accessor :through_model # has_many :through => XYZ
    attr_reader   :name
    attr_reader   :error

    def initialize(model_name)
      @model = find_model(model_name)
      @name = model.to_s unless model.nil?
    end

    def empty?
      @model.nil?
    end

    def valid?
      error.nil?
    end

    def columns
      @columns ||= active_record_columns.collect { |col| col.name }
    end

    def has_column?(col_name)
      model.column_names.include? col_name
    end

    def has_method?(method_name)
      model.new.methods.include?(method_name) || model.new.methods.include?(method_name.to_sym)
    end

    def attributes
      @attributes ||= active_record_columns.collect { |col| AttributeInfo.new self, col.name, col.type }
    end

    def self.is_text_field_attrib_type?(type)
      [:integer, :float, :decimal, :string].include? type
    end

    def text_fields
      attributes.reject { |attrib| !ModelInfo.is_text_field_attrib_type? attrib.type }.collect { |attrib| attrib.name }
    end

    def child_models
      @child_models ||= model_info_array_for_association(:has_many)
    end

    def parent_models
      @parent_models ||= model_info_array_for_association(:belongs_to)
    end

    def has_many_through_models
      @has_many_through_models ||= model_info_array_for_association(:has_many, ActiveRecord::Reflection::ThroughReflection)
    end

    def find_through_model(source_model_name)
      reflections_for_association(:has_many, ActiveRecord::Reflection::ThroughReflection).each do |kvpair|
        reflection_model_name = kvpair[0].to_s.singularize
        if reflection_model_name == source_model_name.underscore
          reflection = kvpair[1]
          return ModelInfo.new(reflection.options[:through].to_s.singularize)
        end
      end
      nil
    end

    def reflections_for_association(association_type, type)
      model.reflections.select { |key, value| value.macro == association_type && value.is_a?(type) }
    end

    def model_info_from_reflection(reflection_model_name, reflection)
      model_info = ModelInfo.new(reflection_model_name)
      if reflection.is_a? ActiveRecord::Reflection::ThroughReflection
        model_info.through_model = ModelInfo.new reflection.options[:through].to_s.singularize
      end
      model_info
    end

    def model_info_array_for_association(association_type, type = ActiveRecord::Reflection::AssociationReflection)
      reflections_for_association(association_type, type).collect do |kvpair|
        reflection_model_name = kvpair[0].to_s.singularize
        reflection = kvpair[1]
        model_info_from_reflection(reflection_model_name, reflection)
      # end.sort do |a, b|
      #   a.name <=> b.name
      end
    end

    def accepts_nested_attributes_for?(child_model)
      if !has_method?("#{child_model.name.underscore.pluralize}_attributes=")
        @error = "Model #{model} does not accept nested attributes for model #{child_model.name}."
        false
      else
        true
      end
    end

    def parent_associations
      reflections_for_association(:belongs_to, ActiveRecord::Reflection::AssociationReflection).collect do |kvpair|
        ParentAssociationInfo.new(kvpair[1])
      end
    end

    def belongs_to?(parent_model_name)
      !association_for(:belongs_to, parent_model_name).nil?
    end

    def has_many?(child_model_name)
      !association_for(:has_many, child_model_name).nil?
    end

    def has_and_belongs_to_many?(model_name)
      !association_for(:has_and_belongs_to_many, model_name).nil?
    end

    def has_many_through?(model_name)
      reflection = association_for(:has_many, model_name.pluralize)
      reflection && reflection.is_a?(ActiveRecord::Reflection::ThroughReflection)
    end

    def has_foreign_key_for?(parent_model_name)
      !foreign_key_for(parent_model_name).nil?
    end

    def foreign_key_for(parent_model_name)
      model.columns.detect { |col| is_foreign_key_for?(col, parent_model_name) }
    end

    def reference_for(col_name)
      reference_reflection = model.reflections.values.detect do |reflection|
        reflection.foreign_key == col_name && (reflection.macro == :has_one || reflection.macro == :belongs_to)
      end
    end

    def parent_reference_for(col_name)
      parent_reflection = model.reflections.values.detect do |reflection|
        reflection.foreign_key == col_name && reflection.macro == :belongs_to
      end
    end

    def parent_model_for(col_name)
      parent_reflection = parent_reference_for(col_name)
      if parent_reflection.nil?
        nil
      end
      if (parent_reflection.options.has_key?(:class_name))
        find_model(parent_reflection.options[:class_name])
      else
        find_model(parent_reflection.name.to_s)
      end
    end

    def reference_model_for(col_name)
      reference_reflection = reference_for(col_name)
      if reference_reflection.nil?
        nil
      end
      class_name = reference_reflection.name.to_s
      if (reference_reflection.macro == :has_one && reference_reflection.options.has_key?(:class))
        class_name = reference_reflection.options[:class]
      elsif (reference_reflection.macro == :belongs_to && reference_reflection.options.has_key?(:class_name))
        class_name = reference_reflection.options[:class_name]
      end
      find_model(class_name)
    end

    def validators
      model.validators
    end

    def get_validator_for(col_name, validator_type)
      model.validators.detect do |validator|
        validator.attributes.include?(col_name.to_sym) && (validator.kind == validator_type)
      end
    end

    def component_assigned_attributes
      model.component_assigned_attributes
    end

    def is_component_assigned?(col_name)
      if model.component_assigned_attributes.nil?
        return false
      else
        model.component_assigned_attributes.detect do |attribute|
          attribute == col_name.to_sym
        end
      end
    end

    def is_write_once?(col_name)
      if model.write_once_attributes.nil?
        false
      else
        model.write_once_attributes.detect do |attribute|
          attribute == col_name.to_sym
        end
      end
    end

    def is_controller_assigned?(col_name)
      if model.controller_assigned_attributes.nil?
        false
      else
        model.controller_assigned_attributes.detect do |attribute|
          attribute == col_name.to_sym
        end
      end
    end

    def is_system?(col_name)
      if model.system_attributes.nil?
        false
      else
        model.system_attributes.detect do |attribute|
          attribute == col_name.to_sym
        end
      end
    end

    def is_enum?(col_name)
      !get_enum_for(col_name).nil?
    end

    def get_enum_for(col_name)
      model.defined_enums.detect { |key, value| (key.to_s == col_name) }
    end

    def is_flags?(col_name)
      !model.flags_attributes.nil? && model.flags_attributes.has_key?(col_name.to_s)
    end

    def flags_for(col_name)
      if is_flags?(col_name)
        model.flags_attributes[col_name]
      end
    end

    def assignable_attribute_names
      @assignable_attribute_names = get_assignable_attribute_names
    end

    def updateable_attribute_names
      @updateable_attribute_names = get_updateable_attribute_names
    end

    def readable_attribute_names
      @readable_attribute_names = get_readable_attribute_names
    end

  private

    def find_model(model_name)
      model = nil
      model_class_name = model_name.camelize
      begin
        model = Object.const_get model_class_name
        if !model.new.kind_of? ActiveRecord::Base
          @error = "Class '#{model_class_name}' is not an ActiveRecord::Base."
          model = nil
        end
      rescue NameError
        @error = "Class '#{model_class_name}' does not exist or contains a syntax error and could not be loaded."
      rescue ActiveRecord::StatementInvalid
        @error = "Table for model '#{model_class_name}' does not exist - run rake db:migrate first."
      end
      model
    end

    def active_record_columns
      @active_record_columns ||= inspect_active_record_columns
    end

    def inspect_active_record_columns
      model.columns.reject do |col|
        is_timestamp?(col) || is_primary_key?(col)
        #is_timestamp?(col) || is_primary_key?(col) || is_foreign_key?(col)
      end
    end

    def is_timestamp?(col)
      %w{ updated_at updated_on created_at created_on }.include? col.name
    end

    def is_primary_key?(col)
      col.name == model.primary_key
    end

    def is_foreign_key?(col)
      model.reflections.values.detect do |reflection|
        col.name == reflection.foreign_key
      end
    end

    def is_foreign_key_for?(col, parent_model_name)
      model.reflections.values.detect do |reflection|
        col.name == reflection.foreign_key && reflection.name == parent_model_name.underscore.to_sym
      end
    end

    def association_for(association, model_name)
      model.reflections.values.detect do |reflection|
        reflection.name == model_name.underscore.to_sym && reflection.macro == association
      end
    end

    def get_assignable_attribute_names
      attribute_names = Array.new
      attributes.each do |attribute|
        if attribute.name == 'password_digest'
          attribute_names.push 'password'
          attribute_names.push 'password_confirmation'
        elsif attribute.is_flags?
          attribute_names.push *attribute.get_flag_attribute_names
        elsif attribute.is_assignable?
          attribute_names.push attribute.name
        end
      end
      attribute_names
    end

    def get_updateable_attribute_names
      attribute_names = Array.new
      attributes.each do |attribute|
        if attribute.name == 'password_digest'
          attribute_names.push 'password'
          attribute_names.push 'password_confirmation'
        elsif attribute.is_flags?
          attribute_names.push *attribute.get_flag_attribute_names
        elsif attribute.is_updateable?
          attribute_names.push attribute.name
        end
      end
      attribute_names
    end

    def attribute_for(column_name)
      attributes.detect { |attribute| attribute.name == column_name }
    end

    def get_readable_attribute_names
      attribute_names = Array.new
      model.columns.each do |column|
        column_attribute = attribute_for(column.name)
        if column_attribute.nil?
          attribute_names.push column.name
        elsif column_attribute.is_flags?
          attribute_names.push *column_attribute.get_flag_attribute_names
        elsif !column_attribute.is_system?
          attribute_names.push column_attribute.name
        end
      end
      attribute_names
    end

  end

end
