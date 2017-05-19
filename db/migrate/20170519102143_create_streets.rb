class CreateStreets < ActiveRecord::Migration[5.0]
  def change
=begin    create_table :streets do |t|
      t.references :cemetery , null:false
      t.string :kind
      t.multi_line_string :geom, srid: 4326
    end
    add_index :streets, :cemetery_id
=end
  end
end
