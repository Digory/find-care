require('minitest/autorun')
require('minitest/rg')
require_relative('../db/seeds_for_testing.rb')
require_relative('../models/ServiceUser.rb')

class ServiceUserTest < MiniTest::Test

  def setup
    @seeds = SeedsForTesting.new()
  end

  def test_all_returns_array_of_correct_size()
    actual = ServiceUser.all().length()
    assert_equal(3, actual)
  end

  def test_save()
    service_user_4 = ServiceUser.new({
      'name' => 'J. Robertson',
      'weekly_budget' => 380
      })
    service_user_4.save()
    actual = ServiceUser.all().length()
    assert_equal(4, actual)
  end

  def test_delete()
    @seeds.service_user_1.delete()
    actual = ServiceUser.all().length()
    assert_equal(2, actual)
  end

  def test_delete_all()
    ServiceUser.delete_all()
    actual = ServiceUser.all().length()
    assert_equal(0, actual)
  end

  def test_find_by_id()
    actual = ServiceUser.find(@seeds.service_user_1.id).name()
    assert_equal("M. Stephens", actual)
  end

  def test_update()
    @seeds.service_user_1.weekly_budget = 400
    @seeds.service_user_1.update()
    actual = @seeds.service_user_1.get_budget_from_database().to_f
    assert_equal(400.00, actual)
  end

  def test_workers__returns_array_of_correct_size()
    actual = @seeds.service_user_1.workers().length()
    assert_equal(1, actual)
  end

  def test_visits__returns_array_of_correct_size()
    actual = @seeds.service_user_1.visits().length()
    assert_equal(2, actual)
  end

  def test_reduce_weekly_budget__reduces_budget()
    @seeds.service_user_1.reduce_weekly_budget?(100)
    service_user_test = ServiceUser.find(@seeds.service_user_1.id())
    actual = service_user_test.weekly_budget()
    assert_equal(700, actual)
  end

  def test_reduce_weekly_budget__returns_false()
    actual = @seeds.service_user_1.reduce_weekly_budget?(900)
    assert_equal(false, actual)
  end


end
