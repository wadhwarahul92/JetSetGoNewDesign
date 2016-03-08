class JsgUpdate < ActiveRecord::Base

  validates :title, presence: true
  validates :description, presence: true
  validates :source_url, presence: true
  validates :image_url, presence: true
  validates :posted_date, presence: true

end
