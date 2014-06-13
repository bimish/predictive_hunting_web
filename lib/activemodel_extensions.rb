module ActiveModel
  module Decorators

    extend ActiveSupport::Concern

    included do
    end

    # custom initializer
    def init_new(signed_in_user)
      if !self.class.new_record_initializer.nil?
        self.send(self.class.new_record_initializer, signed_in_user)
      end
    end

    module ClassMethods

      attr_reader :write_once_attributes
      attr_reader :component_assigned_attributes
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

      def set_new_record_initializer(initializer_method)
        @new_record_initializer = initializer_method
      end

      def new_with_context(attributes, signed_in_user)
        @new_object = new(attributes)

      end

      #include ActiveModel::Decorators::InstanceMethods
    end

    module InstanceMethods

    end

  end
end

#ActiveRecord::Base.send :include, ActiveModel::Decorators
