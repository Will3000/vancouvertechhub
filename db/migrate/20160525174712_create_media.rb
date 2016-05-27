class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :file_name
      t.references :organization, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
