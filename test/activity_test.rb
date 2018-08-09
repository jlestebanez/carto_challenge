require 'mongoid'
require 'test/unit'

require_relative '../models/activity'

class ActivityTest < Test::Unit::TestCase
  Mongoid.load! 'mongo.yaml'

  def test_the_truth
    assert_equal true, true
  end

  def test_load_data
    assert_equal Activity.all.length, 10
  end

  def test_filter_by_location
    cats = Activity.location('outdoors').pluck('location').uniq
    assert_equal cats, ['outdoors']
  end

  def test_filter_by_category
    cats = Activity.category('cultural').pluck('category').uniq
    assert_equal cats, ['cultural']
  end

  def test_filter_by_district
    cats = Activity.district('Centro').pluck('district').uniq
    assert_equal cats, ['Centro']
  end

  def test_can_visit_in_range
    range = '09:00-14:00'
    activity = Activity.title('El Rastro')[0]
    assert_true activity.can_visit_in_range?('su', range)
  end
end
