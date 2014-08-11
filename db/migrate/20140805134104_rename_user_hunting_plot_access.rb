class RenameUserHuntingPlotAccess < ActiveRecord::Migration
  def self.up
    rename_table :user_hunting_plot_access, :hunting_plot_user_access
  end

 def self.down
    rename_table :hunting_plot_user_access, :user_hunting_plot_access
 end
end
