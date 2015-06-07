class HuntingLocationTemporaryAccess < ActiveRecord::Base

  validates_presence_of :hunting_location_id, :user_id, :starts_at, :ends_at

  validates_presence_of :granted_by_id, if: ->(record) { !record.status_pending? }

  belongs_to :hunting_location
  belongs_to :user
  belongs_to :granted_by, class:'User'
  enum status: { status_pending: 0, status_accepted: 1, status_declined: 2 }

  def init_new(signed_in_user)
    super
    # if the user being granted access is the signed-in user, assume this is a request
    # otherwise, assume it is someone (with the appropriate permissions) granting access to the user
    if (self.user_id == signed_in_user.id)
      self.status = HuntingLocationTemporaryAccess.statuses[:status_pending]
    else
      self.status = HuntingLocationTemporaryAccess.statuses[:status_accepted]
      self.granted_by_id = signed_in_user.id
    end
  end

  def authorize_action?(user, action)
    case action
    when :create
      if self.status_pending?
        HuntingPlotUserAccess.can_access?(self.hunting_plot_id, user.id) && self.hunting_location.access_flags_accepts_requests?
      else
        HuntingPlotUserAccess.can_manage_locations?(self.hunting_plot_id, user.id)
      end
    when :read
      self.user_id == user.id || HuntingPlotUserAccess.can_manage_locations?(self.hunting_plot_id, user.id)
    when :update
      HuntingPlotUserAccess.can_manage_locations?(self.hunting_plot_id, user.id)
    when :delete
      (self.user_id == user.id && self.status_pending?) || HuntingPlotUserAccess.can_manage_locations?(self.hunting_plot_id, user.id)
    else
      raise ArgumentError, 'The specified action is not supported'
    end
  end

  def approve(granting_user)

  end

  def hunting_plot_id
    self.hunting_location.hunting_plot_id
  end

end
