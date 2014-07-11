module RelationshipRequestsControllerExtensions

  class ViewData
    def statuses
      @statuses_map ||= RelationshipRequest.statuses.collect { |item| [get_status_description(item[0]), item[0]] }
    end

    def get_status_description(status)
      status.sub("status_", "").humanize
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

