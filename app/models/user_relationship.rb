class UserRelationship < ActiveRecord::Base

  validates :owning_user_id, presence: true
  validates :related_user_id, presence: true
  validates :relationship_type, presence: true

  enum relationship_type: { relationship_type_friend: 1, relationship_type_aquaintence: 2 }

  belongs_to :owning_user, class_name:'User', foreign_key:'owning_user_id'
  belongs_to :related_user, class_name:'User', foreign_key:'related_user_id'

  component_assigned_attribute :owning_user_id
  write_once_attribute :owning_user_id, :related_user_id

  set_new_record_initializer :new_record_init

  def authorize_action?(user, action)
    case action
    when :show, :create, :update, :destroy
      self.owning_user_id == user.id
    # when :create
    #   self.owning_user_id == user.id
    # when :update
    #   self.owning_user_id == user.id
    # when :delete
    #   self.owning_user_id == user.id
    else
      raise ArgumentError, 'The specified action (' + action.to_s + ') is not supported'
    end
  end

  def self.remove_relationship(user_relationship)
    UserRelationship.transaction do
      relationshipRelatedUser = UserRelationship.where(owning_user_id: user_relationship.related_user_id, related_user_id: user_relationship.owning_user_id).first();
      user_relationship.destroy()
      relationshipRelatedUser.destroy()
    end
  end

private
  def new_record_init(signed_in_user)
    self.relationship_type = UserRelationship.relationship_types[:relationship_type_friend] if self.relationship_type.nil?
    self.owning_user_id = signed_in_user.id unless signed_in_user.nil?
  end

end
