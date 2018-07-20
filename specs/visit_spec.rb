require('minitest/autorun')
require('minitest/rg')
# require_relative('../db/test_seeds.rb')
require_relative('../models/ServiceUser.rb')

class VisitTest < MiniTest::Test

  # def setup
  #   seeds = Seeds.new()
  # end

  def test_workers_returns_correct_number()
    actual = $service_user_1.name()
    assert_equal("M. Stephens", actual)
  end

end
