module GeneratorHelpers

  class ModelRoutingInfo

    def initialize(model_name)

      # get routes tied to the controller associated with the model
      routes = Rails.application.routes.routes.collect do |r|
        !r.requirements.empty? && !r.requirements[:controller].blank? && r.requirements[:controller] == model_name.pluralize.underscore
      end

    end



  end

  class RoutingInfo

    attr_reader :model_name
    attr_reader :path_name
    attr_reader :nested_under

    def initialize(model_name)

    end

    def is_nested?

    end

  end

end
