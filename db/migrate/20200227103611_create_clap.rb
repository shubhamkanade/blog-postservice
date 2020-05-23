class CreateClap < ActiveRecord::Migration[6.0]
  def change
    create_table :claps do |clap|
      clap.integer :user_id
      clap.integer :claps
      clap.bigint  :clapable_id
      clap.string  :clapable_type
      clap.timestamps
    end
    add_index :claps, [:clapable_type, :clapable_id]
  end
end
