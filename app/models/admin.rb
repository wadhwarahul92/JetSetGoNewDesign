class Admin < User
  has_paper_trail

  has_many :admin_roleships

end