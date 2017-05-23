class CreatePlots < ActiveRecord::Migration[5.0]
  def change
    create_table :plots do |t|
      t.references :cemetery, null: false, foreign_key: { to_table: :cemeteries }
      t.st_polygon :geom, srid: 4326
      t.string :label, default: "", null: false
      t.timestamps
    end
    add_index :plots, :cemetery_id
  end
end
