require('minitest/autorun')
require('minitest/rg')
require_relative('../db/seeds_for_testing.rb')
require_relative('../models/Worker.rb')

class WorkerTest < MiniTest::Test

  def setup
    @seeds = SeedsForTesting.new()
  end

  def test_all_returns_array_of_correct_size()
    actual = Worker.all().length()
    assert_equal(3, actual)
  end

  def test_save()
    worker_4 = Worker.new({
      'name' => 'Elizabeth S.',
      'gender' => 'f',
      'can_drive' => true,
      'hourly_rate' => 14.50,
      'experience' => 'Epilepsy, Peg Feeds'
      })
    worker_4.save()
    actual = Worker.all().length()
    assert_equal(4, actual)
  end

  def test_delete()
    @seeds.worker_1.delete()
    actual = Worker.all().length()
    assert_equal(2, actual)
  end

  def test_delete_all()
    Worker.delete_all()
    actual = Worker.all().length()
    assert_equal(0, actual)
  end

  def test_find_by_id()
    actual = Worker.find(@seeds.worker_1.id).name()
    assert_equal('James T.', actual)
  end

  def test_update()
    @seeds.worker_1.name = 'Jamie T.'
    @seeds.worker_1.update()
    worker_test = Worker.find(@seeds.worker_1.id)
    actual = worker_test.name()
    assert_equal('Jamie T.', actual)
  end

  def test_visits()
    actual = @seeds.worker_1.visits().length()
    assert_equal(2, actual)
  end

  def test_service_users()
    actual = @seeds.worker_1.service_users().length()
    assert_equal(1, actual)
  end



end
