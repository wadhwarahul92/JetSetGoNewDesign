class AddColumnIosAppDeviceTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :ios_app_devise_token, :string
    add_column :users, :android_app_devise_token, :string
  end
end
