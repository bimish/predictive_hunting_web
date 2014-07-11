module UserRelationshipsControllerExtensions

  class ViewData
    def relationship_types
      @relationship_types_map ||= UserRelationship.relationship_types.collect { |item| [get_relationship_type_description(item[0]), item[0]] }
    end

    def get_relationship_type_description(relationship_type)
      relationship_type.sub("relationship_type_", "").humanize
    end
  end

  extend ActiveSupport::Concern

  included do
    before_action :set_view_data
  end

private

  def set_view_data
    @view_data = ViewData.new()
  end

end

