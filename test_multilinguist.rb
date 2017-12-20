require 'minitest/autorun'
require 'minitest/pride'
require './multilinguist.rb'

class TestMultilinguist < MiniTest::Test

  def setup
    @multilinguist = Multilinguist.new
  end

  def test_language_with_country
    assert_equal("fr", @multilinguist.language_in("France"))
  end

  def test_language_with_invalid_country
    assert_equal("Error", @multilinguist.language_in(""))
  end

end
