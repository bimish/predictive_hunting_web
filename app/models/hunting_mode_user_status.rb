class HuntingModeUserStatus < ActiveRecord::Base

  belongs_to :user
  belongs_to :hunting_plot

  validates :status_type, null: false
  validates :status_text, length: { maximum: 1000 }

  enum status_type: { status_type_checkin: 1, status_type_animal_activity: 2, status_type_chat: 3 }

  component_assigned_attribute :user_id, :status_type
  controller_assigned_attribute :hunting_plot_id

  def self.for_hunting_plot(hunting_plot_id, since_item_id = nil)
    # TODO: evaluate if 100 is the correct limit and look at paging
    results = where(hunting_plot_id: hunting_plot_id)
    unless since_item_id.blank?
      results = results.where('id > ?', since_item_id)
    end
    results = results.preload(:user).order(id: :desc).limit(100)
  end

  def authorize_action?(user, action)
    case action
    when :read
      true # to do - lock this down appropriately
    when :create, :update, :delete
      self.user_id == user.id
    else
      raise ArgumentError, 'The specified action (' + action.to_s + ') is not supported'
    end
  end

  def init_new(signed_in_user)
    super
    self.user_id = signed_in_user.id unless signed_in_user.nil?
  end

end
