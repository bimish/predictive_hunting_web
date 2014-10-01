class HuntingPlotUserAccessRequest < ActiveRecord::Base

  validates :hunting_plot_id, presence: true
  validates :created_by_user_id, presence: true
  validates :message, length: { maximum: 1000 }
  validate :user_or_invite_present # ensure a user id or invite id is present
  validate :check_uniqueness # ensure uniques for hunting plots and user

  belongs_to :user
  belongs_to :user_invitation
  belongs_to :hunting_plot
  belongs_to :created_by_user, class_name:'User'

  controller_assigned_attribute :hunting_plot_id
  component_assigned_attribute :created_by_user_id
  write_once_attribute :user_id, :user_invitation_id, :hunting_plot_id

  is_flags :initial_permissions, HuntingPlotUserAccess.permissions_flags, flag_prefix: 'can'

  attr_accessor :invite_email  # dummy attribute for creating user invites along with plot invite

  after_create :send_invite_email

  def accept(user_id = nil)
    if (user_id.nil? && self.user_id.nil?)
      # can't accept until user has created an account
      errors.add(:base, 'A hunting plot request cannot be accepted until a user has created an account')
    else
      user_id ||= self.user_id
      HuntingPlotUserAccess.transaction do
        HuntingPlotUserAccess.create!(user_id: user_id, hunting_plot_id: self.hunting_plot_id, alias: self.alias, permissions: self.initial_permissions)
        self.destroy!
      end
    end
  end

  def decline
    self.destroy!
  end

  def authorize_action?(user, action)
    case action
    when :read, :create, :update, :delete
      self.user_id == user.id || self.created_by_user_id == user.id
    else
      raise ArgumentError, 'The specified action (' + action.to_s + ') is not supported'
    end
  end

  def init_new(signed_in_user)
    super
    self.initial_permissions = 0
    self.created_by_user_id = signed_in_user.id unless signed_in_user.nil?
  end

private
  def user_or_invite_present
    if self.user_id.nil? && self.user_invitation_id.nil?
      errors.add(:base, 'The access request must have either a user_id or a user_invitation_id')
    end
    if !self.user_id.nil? && !self.user_invitation_id.nil?
      errors.add(:base, 'The access request cannot have both a user_id and a user_invitation_id')
    end
  end

  def check_uniqueness
    if (self.user_id.nil?)
      existing_records = HuntingPlotUserAccessRequest.where(user_invitation_id: self.user_invitation_id).where(hunting_plot_id: self.hunting_plot_id)
      if existing_records.size() > 1 || ((existing_records.size() == 1) && existing_records.first.id != self.id)
        errors.add(:base, "A record already exists for hunting_plot_id #{self.hunting_plot_id} and user_invite_id #{self.user_invitation_id}")
      end
    else
      existing_records = HuntingPlotUserAccessRequest.where(user_id: self.user_id).where(hunting_plot_id: self.hunting_plot_id)
      if existing_records.size() > 1 || ((existing_records.size() == 1) && existing_records.first.id != self.id)
        errors.add(:base, "A record already exists for hunting_plot_id #{self.hunting_plot_id} and user_id #{self.user_id}")
      end
    end
  end

  def send_invite_email
    if (self.user_id.nil?)
      MailHelper.user_invite_email(self.user_invitation, self)
    else
      MailHelper.plot_invite_email(self)
    end
  end

end
