class UserPost < ActiveRecord::Base

  validates :created_by_id, :presence => true
  validates :post_content, :presence => true, length: { maximum: 1000 }
  validates :visibility,
    presence: true,
    :inclusion => { :in => DataDomains::UserPostVisibility.values }

  belongs_to :user, foreign_key: 'created_by_id'

  component_assigned_attribute :created_by_id
  set_new_record_initializer :new_record_init

private
  def new_record_init(signed_in_user)
    self.visibility = DataDomains::UserPostVisibility['Public'] if self.visibility.nil?
    self.created_by_id = signed_in_user.id unless signed_in_user.nil?
  end

end
