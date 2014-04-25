class UserHuntingPlotAccess < ActiveRecord::Base
  belongs_to :user
  belongs_to :hunting_plot
end
