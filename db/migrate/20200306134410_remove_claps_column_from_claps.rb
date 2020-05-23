class RemoveClapsColumnFromClaps < ActiveRecord::Migration[6.0]
  def change
    remove_column :claps, :claps
  end
end
