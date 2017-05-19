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

require 'test_helper'

class PointTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
