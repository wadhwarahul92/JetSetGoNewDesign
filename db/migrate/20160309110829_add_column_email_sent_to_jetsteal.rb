class AddColumnEmailSentToJetsteal < ActiveRecord::Migration
  def change
    add_column :jetsteals, :email_sent, :boolean, default: false
  end
end
