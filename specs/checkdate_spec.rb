require('minitest/autorun')
require('minitest/rg')
require_relative('../db/seeds_for_testing.rb')
require_relative('../models/CheckDate.rb')

class CheckDateTest < MiniTest::Test

  def setup
    @seeds = SeedsForTesting.new()
  end

  def test_is_in_past__returns_true()
    actual = CheckDate.is_in_past?(@seeds.visit_1.visit_date(), @seeds.visit_1.visit_time())
    assert_equal(true, actual)
  end

  def test_is_in_past__returns_false()
    actual = CheckDate.is_in_past?(@seeds.visit_2.visit_date(), @seeds.visit_2.visit_time())
    assert_equal(false, actual)
  end

end
