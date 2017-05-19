# == Schema Information
#
# Table name: points
#
#  id          :integer          not null, primary key
#  cemetery_id :integer          not null
#  kind        :string
#  geom        :geometry({:srid= point, 4326
#  diameter    :float            default("0.0")
#  label       :string           default("")
#

class Point < ApplicationRecord
  belongs_to :cemetery

  def self.choose(cemetery_id)
    sql = <<-SQL.strip_heredoc
      SELECT id, kind, label, ST_AsGeoJSON(geom)::JSON AS geometry
      FROM points
      WHERE cemetery_id = '#{cemetery_id}'
    SQL
    @points = ActiveRecord::Base.connection.execute(sql)
  end
end
