class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :klass_id
      t.integer :member_id

      t.timestamps null: false
    end
    add_index :relationships, :klass_id
    add_index :relationships, :member_id
    add_index :relationships, [:klass_id, :member_id], unique: true
  end
end
