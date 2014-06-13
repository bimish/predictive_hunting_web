class UserRelationship < ActiveRecord::Base

  validates :owning_user_id, presence: true
  validates :related_user_id, presence: true
  validates :relationship_type, presence: true, :inclusion => { :in => DataDomains::UserRelationshipType.values }

  belongs_to :owning_user, class_name:'User' #, foreign_key:'owning_user_id'
  belongs_to :related_user, class_name:'User' #, foreign_key:'related_user_id'

  component_assigned_attribute :owning_user_id
  write_once_attribute :owning_user_id, :related_user_id

  set_new_record_initializer :init_new

private
  def init_new(signed_in_user)
    self.relationship_type = DataDomains::UserRelationshipType['Friend'] if self.relationship_type.nil?
    self.owning_user_id = signed_in_user.id unless signed_in_user.nil?
  end

end
