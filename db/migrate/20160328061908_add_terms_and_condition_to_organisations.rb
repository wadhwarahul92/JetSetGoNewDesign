class AddTermsAndConditionToOrganisations < ActiveRecord::Migration
  def change
    add_column :organisations, :terms_and_condition, :text
  end
end
