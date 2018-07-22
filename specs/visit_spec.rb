require('minitest/autorun')
require('minitest/rg')
require_relative('../db/seeds_for_testing.rb')
require_relative('../models/Visit.rb')
require_relative('../models/ServiceUser.rb')

class VisitTest < MiniTest::Test

  def setup
    @seeds = SeedsForTesting.new()
  end

  def test_all_returns_array_of_correct_size()
    actual = Visit.all().length()
    assert_equal(3, actual)
  end

  def test_save()
    visit_4 = Visit.new({
      'service_user_id' => @seeds.service_user_1.id(),
      'worker_id' => @seeds.worker_1.id(),
      'visit_date' => '2018-09-23',
      'visit_time' => '10:00:00',
      'duration' => 4
      })
    visit_4.save()
    actual = Visit.all().length()
    assert_equal(4, actual)
  end

  def test_delete()
    @seeds.visit_1.delete()
    actual = Visit.all().length()
    assert_equal(2, actual)
  end

  def test_delete_all()
    Visit.delete_all()
    actual = Visit.all().length()
    assert_equal(0, actual)
  end

  def test_find_by_id()
    actual = Visit.find(@seeds.visit_1.id).service_user_id()
    assert_equal(@seeds.service_user_1.id(), actual)
  end

  def test_update()
    @seeds.visit_1.service_user_id = @seeds.service_user_2.id()
    @seeds.visit_1.update()
    service_user_test = Visit.find(@seeds.visit_1.id)
    actual = service_user_test.service_user_id()
    assert_equal(@seeds.service_user_2.id(), actual)
  end

  def test_worker()
    actual = @seeds.visit_1.worker().name()
    assert_equal(@seeds.worker_1.name(), actual)
  end

  def test_service_user()
    actual = @seeds.visit_1.service_user().name()
    assert_equal(@seeds.service_user_1.name(), actual)
  end

  def test_increase_date_by_a_week()
    @seeds.visit_1.increase_date_by_a_week()
    actual = @seeds.visit_1.get_database_visit_date()
    assert_equal('2018-06-08', actual)
  end

  def test_create_with_these_parameters__time_in_expected_format()
    actual = Visit.create_with_these_parameters?(@seeds.service_user_1.id(), @seeds.worker_1.id(), ["monday", "wednesday"], "11:00:00", 2)
    assert_equal(true, actual)
  end

  def test_create_with_these_parameters__time_in_unexpected_format()
    actual = Visit.create_with_these_parameters?(@seeds.service_user_1.id(), @seeds.worker_1.id(), ["monday", "wednesday"], "11 am", 2)
    assert_equal(true, actual)
  end

  def test_create_with_these_parameters__returns_false_if_cost_too_high()
    @seeds.service_user_1.weekly_budget = 5
    @seeds.service_user_1.update()
    actual = Visit.create_with_these_parameters?(@seeds.service_user_1.id(), @seeds.worker_1.id(), ["monday", "wednesday"], "11 am", 2)
    assert_equal(false, actual)
  end


end
