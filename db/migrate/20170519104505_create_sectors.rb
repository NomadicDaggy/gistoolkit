class CreateSectors < ActiveRecord::Migration[5.0]
  def change
=begin    create_table :sectors do |t|
      t.references :cemetery , null:false
      t.string :label
      t.st_polygon :geom, srid: 4326
      t.timestamps
    end

    add_index :sectors, :cemetery_id
=end
  end
end
