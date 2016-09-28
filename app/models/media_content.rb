class MediaContent < ActiveRecord::Base

  acts_as_paranoid

  validates :one_liner, presence: true

  validates :description, presence: true

  validates :image_url, presence: true

  validates :redirect_url, presence: true

end
