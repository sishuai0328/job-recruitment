class RemoveColumnPostIdIntoLike < ActiveRecord::Migration[5.0]
  def change
    remove_column :likes, :post_id ,:integer
  end
end
