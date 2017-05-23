class CreateSectors < ActiveRecord::Migration[5.0]
  def change
    create_table :sectors do |t|
      t.references :cemetery , null:false, foreign_key: { to_table: :cemeteries }
      t.string :label
      t.st_polygon :geom, srid: 4326
      t.timestamps
    end

    add_index :sectors, :cemetery_id
  end
end
