class AddColumnProcessorResponseToPaymentTransaction < ActiveRecord::Migration
  def change
    add_column :payment_transactions, :processor_response, :text
  end
end
