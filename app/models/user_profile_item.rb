class UserProfileItem < ActiveRecord::Base

  validates :name, presence: true, length: { maximum: 100 }
  validates :label, presence: true, length: { maximum: 255 }
  validates :data_type, presence: true
  validates :validation_expression, length: { maximum: 512 }
  validates :validation_message, length: { maximum: 255 }

  validate :validate_value_list

  enum data_type: { data_type_string: 1, data_type_integer: 2, data_type_date: 3, data_type_boolean: 4 }

  is_flags :flags, { 0 => :is_required, 1 => :is_multi_valued }

  before_save :init_flags

private
  def validate_value_list
    if !self.value_list.blank? && self.value_list_changed?
      unless valid_json?(self.value_list)
        errors.add(:value_list, "cannot be parsed as valid json")
      end
    end
  end

  def init_flags
    if self.flags.nil?
      self.flags = 0
    end
  end

end
