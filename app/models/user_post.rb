class UserPost < ActiveRecord::Base

  validates :created_by_id, :presence => true
  validates :post_content, :presence => true, length: { maximum: 1000 }
  validates :visibility,
    presence: true #,
    #:inclusion => { :in => DataDomains::UserPostVisibility.values }

  enum visibility: { visibility_public: 1, visibility_private: 2 }

  belongs_to :user, foreign_key: 'created_by_id'
  has_one :user_relationship

  component_assigned_attribute :created_by_id

  def self.from_related_users(user)
    related_user_ids = "SELECT related_user_id FROM user_relationship WHERE owning_user_id = :user_id"
    where(
      "created_by_id IN (#{related_user_ids}) or created_by_id = :user_id",
      related_user_ids: related_user_ids,
      user_id: user)
  end

  def init_new(signed_in_user)
    super
    self.visibility = DataDomains::UserPostVisibility['Public'] if self.visibility.nil?
    self.created_by_id = signed_in_user.id unless signed_in_user.nil?
  end

private


end
