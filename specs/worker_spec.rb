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
    assert_equal(6, actual)
  end

  def test_save()
    worker_7 = Worker.new({
      'name' => 'Elizabeth S.',
      'gender' => 'f',
      'can_drive' => true,
      'hourly_rate' => 14.50,
      'experience' => 'Epilepsy, Peg Feeds'
      })
    worker_7.save()
    actual = Worker.all().length()
    assert_equal(7, actual)
  end

  def test_delete()
    @seeds.worker_1.delete()
    actual = Worker.all().length()
    assert_equal(5, actual)
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

  def test_sort_by_cost()
    sorted_workers = Worker.sort_by_cost(Worker.all())
    actual = sorted_workers[0].id()
    assert_equal(@seeds.worker_4.id(), actual)
  end

  def test_filtered_search__any_gender_any_experience()
    actual = Worker.filtered_search("a", "a", 100, "any").length()
    assert_equal(6, actual)
  end

  def test_filtered_search__male_any_experience()
    actual = Worker.filtered_search("m", "a", 100, "any").length()
    assert_equal(3, actual)
  end

  def test_filtered_search__female_any_experience()
    actual = Worker.filtered_search("f", "a", 100, "any").length()
    assert_equal(3, actual)
  end

  def test_filtered_search__male_driver_any_experience()
    actual = Worker.filtered_search("m", "t", 100, "any").length()
    assert_equal(2, actual)
  end

  def test_filtered_search__female_driver_hourly_rate_11_any_experience()
    actual = Worker.filtered_search("f", "t", 11, "any").length()
    assert_equal(1, actual)
  end

  def test_filtered_search__male_driver_hourly_rate_14_autism_experience()
    actual = Worker.filtered_search("m", "t", 14, ["Autism"]).length()
    assert_equal(1, actual)
  end

  def test_filtered_search__female_driver_hourly_rate_14_multiple_experience()
    actual = Worker.filtered_search("f", "t", 14, ["Children", "Moving and Handling"]).length()
    assert_equal(1, actual)
  end

  def test_keyword_search__partial_word()
    actual = Worker.keyword_search('irst').length()
    assert_equal(2, actual)
  end

  def test_keyword_search__multiple_words()
    actual = Worker.keyword_search('irst aid').length()
    assert_equal(2, actual)
  end

  def test_keyword_search__case_insensitive()
    actual = Worker.keyword_search('aUTIsm').length()
    assert_equal(3, actual)
  end

  def test_keyword_search__letters_wrong()
    actual = Worker.keyword_search('syn language').length()
    assert_equal(1, actual)
  end

  def test_keyword_search__leading_spaces()
    actual = Worker.keyword_search('  syn language').length()
    assert_equal(1, actual)
  end

  def test_keyword_search__trailing_spaces()
    actual = Worker.keyword_search('syn language  ').length()
    assert_equal(1, actual)
  end

  def test_keyword_search__keywords_correct_word()
    actual = Worker.keyword_search('driver').length()
    assert_equal(4, actual)
  end

  def test_keyword_search__keywords_word_spelling_wrong()
    actual = Worker.keyword_search('chep').length()
    assert_equal(2, actual)
  end

  def test_keyword_search__keywords_gender_spelling_wrong_1()
    actual = Worker.keyword_search('mans').length()
    assert_equal(3, actual)
  end

  def test_keyword_search__keywords_gender_spelling_wrong_2()
    actual = Worker.keyword_search('wimen').length()
    assert_equal(3, actual)
  end



end
