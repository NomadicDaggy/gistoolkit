# == Schema Information
#
# Table name: cemeteries
#
#  id                     :integer          not null, primary key
#  account_id             :integer          not null
#  geom                   :geometry({:srid= polygon, 4326
#  label                  :string           default(""), not null
#  name                   :string
#  created_at             :datetime
#  updated_at             :datetime
#  settings               :text
#  contract_template_id   :integer
#  bill_template_id       :integer
#  email                  :string
#  address                :string
#  phone_number           :string
#  web_address            :string
#  published_in_web       :boolean          default("false")
#  digitized              :boolean          default("false")
#  description            :text
#  supporter_info         :string
#  intention              :string
#  status                 :string
#  cultural_monument      :boolean          default("false")
#  visit_time_h_from      :string
#  visit_time_h_to        :string
#  country_domain         :string
#  city                   :string
#  region                 :string
#  unrecognizable_options :boolean          default("false")
#  geo_ratio              :decimal(20, 16)
#  full_text              :text
#  file                   :string
#

class Cemetery < ActiveRecord::Base
  include Featurable

  featurable :geom, [:name]

  def self.choose(cemetery_id)
    sql = <<-SQL.strip_heredoc
      SELECT id, name, ST_AsGeoJSON(geom)::JSON AS geometry
      FROM cemeteries
      WHERE id = '#{cemetery_id}'
    SQL
    @cemeteries = ActiveRecord::Base.connection.execute(sql)
  end

  def central_coordinates
    sql = "SELECT ST_asgeojson(ST_Centroid(geom)) FROM cemeteries where id = #{self.id};"
    cursor = Cemetery.connection.execute(sql)
    geojson = cursor.first['st_asgeojson']
    hash = MultiJson.load(geojson)
    coordinates = hash['coordinates']
    { lat: coordinates[1], lng: coordinates[0] }
  end
end
