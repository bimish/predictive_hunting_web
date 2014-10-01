class UserInvitation < ActiveRecord::Base

  validates :email, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :created_by_id, presence: true
  validates :message, length: { maximum: 1000 }
  validates :status, presence: true

  enum status: { status_new: 1, status_accepted: 2, status_rejected: 3 }

  belongs_to :created_by_user, class_name:'User', foreign_key:'created_by_id'
  has_many :plot_invitations, class_name:'HuntingPlotUserAccessRequest'

  component_assigned_attribute :created_by_id, :status
  write_once_attribute :created_by_id, :email

  attr_accessor :skip_invite_email # can be set to true if the default notifications should not be sent
  after_create :send_invite_email

  def authorize_action?(user, action)
    case action
    when :read, :create, :update, :delete
      self.created_by_id == user.id
    else
      raise ArgumentError, 'The specified action (' + action.to_s + ') is not supported'
    end
  end

  def init_new(signed_in_user)
    super
    self.status = UserInvitation.statuses[:status_new] if self.status.nil?
    self.created_by_id = signed_in_user.id unless signed_in_user.nil?
  end

  def get_display_name
    self.email
  end

  def accepted(user)
    # process any pending plot invitations and then destroy this record since it is no longer needed
    ActiveRecord::Base.transaction do
      self.plot_invitations.each do |plot_invitation|
        plot_invitation.accept(user.id)
      end
      self.destroy
    end
  end

private

  def send_invite_email
    unless self.skip_invite_email
      MailHelper.user_invite_email(self)
    end
  end

end
