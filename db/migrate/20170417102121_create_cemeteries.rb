class CreateCemeteries < ActiveRecord::Migration[5.0]
  def change
    create_table :cemeteries do |t|
      t.integer  :account_id,                                                                                            null: false
      t.st_polygon :geom, srid: 3857
      t.string   :label,                                                                                    default: "", null: false
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
      t.text     :settings
      t.integer  :contract_template_id
      t.integer  :bill_template_id
      t.string   :email
      t.string   :address
      t.string   :phone_number
      t.string   :web_address
      t.boolean  :published_in_web,                                                                         default: false
      t.boolean  :digitized,                                                                                default: false
      t.text     :description
      t.string   :supporter_info
      t.string   :intention
      t.string   :status
      t.boolean  :cultural_monument,                                                                        default: false
      t.string   :visit_time_h_from
      t.string   :visit_time_h_to
      t.string   :country_domain
      t.string   :city
      t.string   :region
      t.boolean  :unrecognizable_options,                                                                   default: false
      t.decimal  :geo_ratio,                                                      precision: 20, scale: 16
      t.text     :full_text
      t.string   :file
    end
  end
end
