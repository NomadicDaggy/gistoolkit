# == Schema Information
#
# Table name: streets
#
#  id          :integer          not null, primary key
#  cemetery_id :integer          not null
#  kind        :string
#  geom        :geometry({:srid= multilinestring, 4326
#

class Street < ApplicationRecord
  belongs_to :cemetery

  def self.choose(cemetery_id)
    sql = <<-SQL.strip_heredoc
      SELECT id, kind, ST_AsGeoJSON(geom)::JSON AS geometry
      FROM streets
      WHERE cemetery_id = '#{cemetery_id}'
    SQL
    @streets = ActiveRecord::Base.connection.execute(sql)
  end
end
