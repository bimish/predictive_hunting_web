module ActiveModel
  module Decorators

    extend ActiveSupport::Concern

    included do
    end

    # custom initializer
    def init_new(signed_in_user)
      # can be overridden in the models to initialize new instances
    end

    module ClassMethods

      attr_reader :write_once_attributes
      attr_reader :component_assigned_attributes
      attr_reader :controller_assigned_attributes
      attr_reader :flags_attributes
      attr_reader :system_attributes
      attr_reader :new_record_initializer

      def write_once_attribute(*attribute_list)
        if @write_once_attributes.nil?
          @write_once_attributes = attribute_list
        else
          @write_once_attributes.push attribute_list
        end
      end

      def component_assigned_attribute(*attribute_list)
        if @component_assigned_attributes.nil?
          @component_assigned_attributes = attribute_list
        else
          @component_assigned_attributes.push attribute_list
        end
      end

      def controller_assigned_attribute(*attribute_list)
        if @controller_assigned_attributes.nil?
          @controller_assigned_attributes = attribute_list
        else
          @controller_assigned_attributes.push attribute_list
        end
      end

      def system_attribute(*attribute_list)
        if @system_attributes.nil?
          @system_attributes = attribute_list
        else
          @system_attributes.push attribute_list
        end
      end

      def is_flags(attribute, flag_values, options = {})

        attribute_name = attribute.to_s
        @flags_attributes ||= Hash.new
        @flags_attributes[attribute_name] = { values: flag_values, options: options }

        flag_values.each do |value, flag|

          flag_name = flag.to_s
          flag_value = value.to_s

          if (options[:flag_prefix].blank?)
            field_name = "#{attribute_name}_#{flag_name}"
          else
            field_name = "#{attribute_name}_#{options[:flag_prefix]}_#{flag_name}"
          end

          class_eval %{
            class << self
              def #{field_name}_bit
                (1 << #{flag_value})
              end
            end

            def #{field_name}
              (self.#{attribute_name} & self.class.#{field_name}_bit) == self.class.#{field_name}_bit
            end

            alias #{field_name}? #{field_name}

            def #{field_name}=(v)
              if v.to_s == "true" || v.to_s == "1"
                self.#{attribute_name} = (#{attribute_name} || 0) | self.class.#{field_name}_bit
              else
                self.#{attribute_name} = (#{attribute_name} || 0) & ~self.class.#{field_name}_bit
              end
            end
          }
        end
      end

      #include ActiveModel::Decorators::InstanceMethods
    end

    module InstanceMethods

    end

  end
end

#ActiveRecord::Base.send :include, ActiveModel::Decorators
