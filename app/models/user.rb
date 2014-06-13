class User < ActiveRecord::Base

  has_secure_password

  before_save { self.email.downcase! }
  before_save { self.authentication_method = 1 }
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :first_name, presence:true, length: { maximum: 100 }

  validates :last_name, presence:true, length: { maximum: 100 }

  validates :email,
    presence:true,
    length: { maximum: 254 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  validates :password,
    presence:true,
    length: { minimum: 6 },
    if: ->(record) { record.new_record? || record.password.present? || password_confirmation.present?  }

  validates :password_confirmation,
    presence:true,
    if: ->(record) { record.new_record? || record.password_confirmation.present? || password.present?  }

  attr_readonly :admin

  has_many :hunting_plot_accesses, class_name:'UserHuntingPlotAccess'
  has_many :hunting_plots, through: :hunting_plot_accesses, class_name:'HuntingPlot'

  has_many :relationships, class_name:'UserRelationship', foreign_key:'owning_user_id' #, inverse_of: :owning_user
  has_many :users_followed, through: :relationships, class_name:'User', source: :related_user

  has_many :reverse_relationships, class_name:'UserRelationship', foreign_key:'related_user_id' # inverse_of: :related_user
  has_many :users_following, through: :reverse_relationships, class_name:'User', source: :owning_user #, inverse_of: :related_user

  has_many :posts, class_name:'UserPost', foreign_key:'created_by_id'

  def following?(other_user)
    relationships.find_by_related_used_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(related_user_id: other_user.id, relationship_type: DataDomains::UserRelationshipType['Friend'])
  end

  def unfollow!(other_user)
    relationships.find_by_related_used_id(other_user.id).destroy
  end

  def get_display_name
    self.alias
  end

private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
