# == Schema Information
#
# Table name: sectors
#
#  id          :integer          not null, primary key
#  cemetery_id :integer          not null
#  geom        :geometry({:srid= polygon, 4326
#  label       :string           default(""), not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Sector < ApplicationRecord
  belongs_to :cemetery

  def self.choose(cemetery_id)
    sql = <<-SQL.strip_heredoc
      SELECT id, label, ST_AsGeoJSON(geom)::JSON AS geometry
      FROM sectors
      WHERE cemetery_id = '#{cemetery_id}'
    SQL
    @sectors = ActiveRecord::Base.connection.execute(sql)
  end
end
