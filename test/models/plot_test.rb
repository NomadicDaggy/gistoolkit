# == Schema Information
#
# Table name: plots
#
#  id          :integer          not null, primary key
#  cemetery_id :integer          not null
#  geom        :geometry({:srid= polygon, 4326
#  label       :string           default(""), not null
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class PlotTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
