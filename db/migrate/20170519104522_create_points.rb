class CreatePoints < ActiveRecord::Migration[5.0]
  def change
    create_table :points do |t|
      t.references :cemetery , null:false, foreign_key: { to_table: :cemeteries }
      t.string :label
      t.string :kind
      t.float :diameter , default:0 , null:false
      t.st_point :geom, srid: 4326
    end
    add_index :points, :cemetery_id
    add_foreign_key :points, :cemeteries
  end
end
