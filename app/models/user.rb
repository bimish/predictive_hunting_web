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

  validates :admin, inclusion: [true,false]

  enum authentication_method: { authentication_method_direct: 1, authentication_method_facebook: 2, authentication_method_google: 3 }

  attr_readonly :admin

  has_many :hunting_plot_accesses, class_name:'HuntingPlotUserAccess'
  has_many :hunting_plots, through: :hunting_plot_accesses, class_name:'HuntingPlot'
  has_many :hunting_plot_invitations, class_name:'HuntingPlotUserAccessRequest'
  has_many :network_subscriptions, class_name:'UserNetworkSubscription'
  has_many :posts, class_name:'UserPost', foreign_key:'created_by_id'
  has_many :relationships, class_name:'UserRelationship', foreign_key:'owning_user_id' #, inverse_of: :owning_user
  has_many :reverse_relationships, class_name:'UserRelationship', foreign_key:'related_user_id' # inverse_of: :related_user
  has_many :users_followed, through: :relationships, class_name:'User', source: :related_user
  has_many :users_following, through: :reverse_relationships, class_name:'User', source: :owning_user #, inverse_of: :related_user
  has_many :profile_item_values, class_name:'UserProfileItemValue'

  system_attribute :remember_token
  component_assigned_attribute :password_digest, :remember_token, :authentication_method, :admin
  write_once_attribute :email

  def get_display_name
    if self.alias.nil?
      "#{self.first_name} #{self.last_name}"
    else
      "#{self.first_name} #{self.last_name} (#{self.alias})"
    end
  end

  def has_pending_relationship_requests?
    RelationshipRequest.user_has_pending_requests?(self)
  end

  def has_pending_plot_invites?
    HuntingPlotUserAccessRequest.user_has_pending_invites?(self)
  end

  def self.from_related_users(user)
    joins(:reverse_relationships).where('user_relationship.owning_user_id = ?', user.id)
  end

  def self.search_new_friends(current_user, name_criteria)
    search_results = joins("LEFT OUTER JOIN user_relationship ON (\"user\".id = user_relationship.related_user_id AND user_relationship.owning_user_id = #{current_user.id})")
    search_results = search_results.where('user_relationship.related_user_id IS NULL')
    search_results = search_results.where(admin: false)
    search_results = search_results.where.not(id: current_user.id)
    if !name_criteria.blank?
      name_parts = name_criteria.split()
      user_query = User.arel_table
      names_clause = nil
      name_parts.each do |name|
        name = "%#{name}%"
        if names_clause.nil?
          names_clause = user_query[:first_name].matches(name)
        else
          names_clause = names_clause.or(user_query[:first_name].matches(name))
        end
        names_clause = names_clause.or(user_query[:last_name].matches(name))
      end
      search_results = search_results.where(names_clause)
    end
    search_results
  end

  def authorize_action?(user, action)
    case action
    when :read
      self.id == user.id
    when :create
      user.nil? || user.admin? # user is not currently signed in or user is an admin
    when :update
      self.id == user.id
    when :destroy
      false
    else
      raise ArgumentError, 'The specified action is not supported'
    end
  end

  def init_new(signed_in_user)
    super
    self.authentication_method = User.authentication_methods[:authentication_method_direct]
  end

private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
