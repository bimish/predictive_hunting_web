class HuntingModeUserStatus < ActiveRecord::Base

  belongs_to :user
  belongs_to :hunting_plot

  validates :status_id, null: false
  validates :status_text, length: { maximum: 1000 }

  component_assigned_attribute :created_by_id

end
