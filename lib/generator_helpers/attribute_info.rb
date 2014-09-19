require 'rails/generators/generated_attribute'

module GeneratorHelpers

  class AttributeInfo < Rails::Generators::GeneratedAttribute

    def initialize(model, attribute_name, attribute_type=nil, index_type=false, attr_options={})
      super(attribute_name, attribute_type, index_type, attr_options)
      @source_model = model
    end

    def parent_reference?
      !self.parent_reference.nil?
    end

    def parent_reference
      @parent_reference ||= @source_model.parent_reference_for self.name
    end

    def parent_reference_model
      @parent_reference_model ||= @source_model.parent_model_for self.name
    end

    def reference?
      !self.reference.nil?
    end

    def reference
      @reference ||= @source_model.reference_for self.name
    end

    def reference_model
      @reference_model ||= @source_model.reference_model_for self.name
    end

    def required?
      validator = @source_model.get_validator_for(self.name, :presence)
      !validator.nil?
    end

    def length
      validator = @source_model.get_validator_for(self.name, :length)
      (validator.nil? || validator.options[:maximum].nil?) ? 255 : validator.options[:maximum]
    end

    def has_value_list?
      validator = @source_model.get_validator_for(self.name, :inclusion)
      validator.nil? ? false : !validator.options[:in].nil?
    end

    def is_enum?
      @source_model.is_enum?(self.name)
    end

    def is_component_assigned?
      @source_model.is_component_assigned?(self.name)
    end

    def is_controller_assigned?
      @source_model.is_controller_assigned?(self.name)
    end

    def is_write_once?
      @source_model.is_write_once?(self.name)
    end

    def is_flags?
      @source_model.is_flags?(self.name)
    end

    def is_system?
      @source_model.is_system?(self.name)
    end

    def is_updateable?
      self.is_assignable? && !self.is_write_once? && !self.is_system?
    end

    def is_assignable?
      !self.is_component_assigned? && !self.is_controller_assigned? && !self.is_system?
    end

    def flags
      @source_model.flags_for(self.name)
    end

    def flag_attribute_name(flag_value)
      if (flag_value.is_a? String)
        flag_name = flag_value
      elsif (flag_value.is_a? Symbol)
        flag_name = flag_value.to_s
      else
        flag_name = self.flags[:values][flag_value].to_s
      end
      flag_options = self.flags[:options]
      if flag_options[:flag_prefix].blank?
        "#{self.name}_#{flag_name}"
      else
        "#{self.name}_#{flag_options[:flag_prefix]}_#{flag_name}"
      end
    end

    def get_flag_attribute_names
      self.flags[:values].collect do |flag_value, flag_name|
        self.flag_attribute_name(flag_value)
      end
    end

    def password_digest?
      name == 'password_digest' && type == :string
    end

    def display_value_string

    end

    private

  end

end
