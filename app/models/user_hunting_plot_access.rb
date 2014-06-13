class UserHuntingPlotAccess < ActiveRecord::Base
  belongs_to :user
  belongs_to :hunting_plot

  write_once_attribute :user_id, :hunting_plot_id
end
