# == Schema Information
#
# Table name: streets
#
#  id          :integer          not null, primary key
#  cemetery_id :integer          not null
#  kind        :string
#  geom        :geometry({:srid= multilinestring, 4326
#

require 'test_helper'

class StreetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
