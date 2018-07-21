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

  def test_find_by_gender__m()
    actual = Worker.find_by_gender('m').length()
    assert_equal(2, actual)
  end

  def test_find_by_gender__f()
    actual = Worker.find_by_gender('f').length()
    assert_equal(1, actual)
  end

  def test_find_by_can_drive__true()
    actual = Worker.find_by_can_drive(true).length()
    assert_equal(2, actual)
  end

  def test_find_by_can_drive__false()
    actual = Worker.find_by_can_drive(false).length()
    assert_equal(1, actual)
  end

  def test_find_by_hourly_rate()
    actual = Worker.find_by_hourly_rate(8.90).length()
    assert_equal(1, actual)
  end

  def test_find_by_experience_specific__single_word()
    actual = Worker.find_by_experience_specific('Autism').length()
    assert_equal(2, actual)
  end

  def test_find_by_experience_specific__multiple_words()
    actual = Worker.find_by_experience_specific('Autism, Children').length()
    assert_equal(1, actual)
  end

  def test_find_by_experience_fuzzy__partial_word()
    actual = Worker.find_by_experience_fuzzy('irst').length()
    assert_equal(1, actual)
  end

  def test_find_by_experience_fuzzy__case_insensitive()
    actual = Worker.find_by_experience_fuzzy('aUTIsm').length()
    assert_equal(2, actual)
  end

  def test_find_by_experience_fuzzy__letters_missing()
    actual = Worker.find_by_experience_fuzzy('tism').length()
    assert_equal(2, actual)
  end

  def test_find_by_experience_fuzzy__letters_wrong()
    actual = Worker.find_by_experience_fuzzy('syn language').length()
    assert_equal(1, actual)
  end



end
