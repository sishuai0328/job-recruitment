class AddAvatarToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :avatar, :string
  end
end
