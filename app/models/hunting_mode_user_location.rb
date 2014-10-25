class HuntingModeUserLocation < ActiveRecord::Base

  belongs_to :user
  belongs_to :hunting_plot
  belongs_to :hunting_location

  set_rgeo_factory_for_column(:location_coordinates, RGeo::Geographic.spherical_factory(:srid => 4326))

  component_assigned_attribute :created_by_id

  def expired?
    self.updated_at < expiration_cut_off
  end

  def self.non_expired_for_plot(hunting_plot_id)
    where(hunting_plot_id: hunting_plot_id).where('updated_at > ?', expiration_cut_off)
  end

  def self.current_for_location(hunting_location_id)
    where(hunting_location_id: hunting_location_id).where('updated_at > ?', expiration_cut_off).order(updated_at: :desc).limit(1).first
  end

private
  def self.expiration_cut_off
    # for a status update to be still valid, it must have occured on the same date as the current date
    current_date = Time.now
    Time.new(current_date.year, current_date.month, current_date.day)
  end

  def expiration_cut_off
    HuntingModeUserLocation.expiration_cut_off
  end

end
