class YatraEnquiry < ActiveRecord::Base

  validates :name, presence: true
  validates :email, presence: true
  validates :mobile_number, presence: true
  validates :package, presence: true
  validates :date_of_travel, presence: true

end
