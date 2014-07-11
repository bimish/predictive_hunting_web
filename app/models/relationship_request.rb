class RelationshipRequest < ActiveRecord::Base

  validates :created_by_id, presence: true
  validates :related_user_id, presence: true
  validates :status, presence: true

  enum status: { status_new: 1, status_accepted: 2, status_ignored: 3, status_rejected: 4 }

  belongs_to :created_by_user, class_name:'User' #, foreign_key:'owning_user_id'
  belongs_to :related_user, class_name:'User' #, foreign_key:'related_user_id'

  component_assigned_attribute :created_by_id
  write_once_attribute :created_by_id, :related_user_id

  set_new_record_initializer :new_record_init

private
  def new_record_init(signed_in_user)
    self.status = RelationshipRequest.statuses[:status_new] if self.status.nil?
    self.created_by_id = signed_in_user.id unless signed_in_user.nil?
  end

end
