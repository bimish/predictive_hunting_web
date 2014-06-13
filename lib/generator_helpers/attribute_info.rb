require 'rails/generators/generated_attribute'

module GeneratorHelpers

  class AttributeInfo < Rails::Generators::GeneratedAttribute

    def initialize(model, attribute_name, attribute_type=nil, index_type=false, attr_options={})
      super(attribute_name, attribute_type, index_type, attr_options)
      @source_model = model
    end

    def reference?
      !self.reference.nil?
    end

    def reference
      @reference ||= @source_model.parent_reference_for self.name
    end

    def reference_model
      @reference_model ||= @source_model.parent_model_for self.name
    end

    def required?
      validator = @source_model.get_validator_for(self.name, :presence)
      return !validator.nil?
    end

    def length
      validator = @source_model.get_validator_for(self.name, :length)
      return validator.nil? ? nil : validator.options[:maximum]
    end

    def has_value_list?
      validator = @source_model.get_validator_for(self.name, :inclusion)
      return validator.nil? ? false : !validator.options[:in].nil?
    end

    def is_component_assigned?
      return @source_model.is_component_assigned?(self.name)
    end

    def is_write_once?
      return @source_model.is_write_once?(self.name)
    end

    private

  end

end
