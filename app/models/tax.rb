class Tax < ActiveRecord::Base

  validates_presence_of :service_tax, :swachh_bharat_cess

  class <<self

    def tax
      {
          service_tax: 14.5,
          swachh_bharat_cess: 0.5
      }
    end

    def total_tax_value
      # amount = 0.0
      # self.tax.each_value{ |value| amount += value }
      # amount
      15.0
    end

  end

end