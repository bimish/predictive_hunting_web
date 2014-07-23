class RelationshipRequest < ActiveRecord::Base

  validates :created_by_id, presence: true
  validates :related_user_id, presence: true, :uniqueness => { :scope => :created_by_id }
  validates :status, presence: true

  enum status: { status_new: 1, status_accepted: 2, status_rejected: 3 }

  belongs_to :created_by_user, class_name:'User', foreign_key:'created_by_id'
  belongs_to :related_user, class_name:'User', foreign_key:'related_user_id'

  component_assigned_attribute :created_by_id
  write_once_attribute :created_by_id, :related_user_id

  set_new_record_initializer :new_record_init

  def self.user_has_pending_requests?(user)
    RelationshipRequest.exists?(related_user_id: user.id, status: RelationshipRequest.statuses[:status_new])
  end

  def self.pending_requests_for_user(user)
    RelationshipRequest.where(related_user_id: user.id, status: RelationshipRequest.statuses[:status_new])
  end

  def accept
    unless self.status_new?
      raise Exceptions::InvalidState, "The relationship request (id=#{self.id}) does not have a status of #{RelationshipRequest.statuses[:status_new]}"
    end
    UserRelationship.transaction do
      self.update!(status: RelationshipRequest.statuses[:status_accepted])
      UserRelationship.create!(owning_user_id: self.created_by_id, related_user_id:self.related_user_id, relationship_type: UserRelationship.relationship_types[:relationship_type_friend])
      UserRelationship.create!(owning_user_id: self.related_user_id, related_user_id: self.created_by_id, relationship_type: UserRelationship.relationship_types[:relationship_type_friend])
      self.destroy!
    end
  end

  def reject
    self.update!(status: RelationshipRequest.statuses[:status_rejected])
  end

  def authorize_action?(user, action)
    case action
    when :show
      self.created_by_id == user.id || self.related_user_id == user.id
    when :create
      true
    when :update
      self.created_by_id == user.id || self.related_user_id == user.id
    when :destroy
      self.created_by_id == user.id
    else
      raise ArgumentError, 'The specified action is not supported'
    end
  end

private
  def new_record_init(signed_in_user)
    self.status = RelationshipRequest.statuses[:status_new] if self.status.nil?
    self.created_by_id = signed_in_user.id unless signed_in_user.nil?
  end

end
