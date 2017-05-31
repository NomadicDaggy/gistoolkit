# == Schema Information
#
# Table name: cemeteries
#
#  id           :integer          not null, primary key
#  geom         :geometry({:srid= polygon, 4326
#  name         :string
#  created_at   :datetime
#  updated_at   :datetime
#  address      :string
#  phone_number :string
#  city         :string
#  region       :string
#

class Cemetery < ActiveRecord::Base
  has_many :plots

  # Atlasa kontroliera pieprasītās kapsētas datus no datubāzes.
  def self.choose(cemetery_id)
    sql = <<-SQL.strip_heredoc
      SELECT id, name, address, phone_number, city, region, ST_AsGeoJSON(geom)::JSON AS geometry
      FROM cemeteries
      WHERE id = '#{cemetery_id}'
    SQL
    @cemeteries = ActiveRecord::Base.connection.execute(sql)
  end

  # Nosaka kapsētu ierobežojošā daudzstūra centrpunkta koordinātas.
  def central_coordinates
    sql = "SELECT ST_asgeojson(ST_Centroid(geom)) FROM cemeteries where id = #{self.id};"
    cursor = Cemetery.connection.execute(sql)
    geojson = cursor.first['st_asgeojson']
    hash = MultiJson.load(geojson)
    coordinates = hash['coordinates']
    { lat: coordinates[1], lng: coordinates[0] }
  end
end
