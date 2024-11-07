require "test_helper"

class ChurchesHelperTest < ActionView::TestCase
  include ChurchesHelper

  def test_distance_to_human_with_nil
    assert_nil distance_to_human(nil)
  end

  def test_distance_to_human_with_distance_greater_than_or_equal_to_1_km
    assert_equal "1.0 km", distance_to_human(1.0)
    assert_equal "1.5 km", distance_to_human(1.5)
    assert_equal "2.0 km", distance_to_human(2.0)
  end

  def test_distance_to_human_with_distance_less_than_1_km
    assert_equal "500 m", distance_to_human(0.5)
    assert_equal "750 m", distance_to_human(0.75)
    assert_equal "999 m", distance_to_human(0.999)
  end
end
