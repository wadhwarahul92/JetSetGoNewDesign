class Distance < ActiveRecord::Base

  has_paper_trail

  ####VALIDATIONS###
  validates :from_airport_id, uniqueness: {scope: :to_airport_id}
  validates :to_airport_id, presence: true, uniqueness: {scope: :from_airport_id}
  validates :distance_in_nm, presence: true
  validate def check_from_and_to_differs
    self.errors.add(:to_airport_id, 'must be different') if self.from_airport_id == self.to_airport_id
  end
  ##################
end
