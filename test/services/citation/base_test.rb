require 'benchmark'
require "test_helper"
require_relative "citation_test_subjects"

class BaseTest < ActiveSupport::TestCase
  include CitationTestSubjects

  def subject1
    @subject1 ||= Citation::Base.new(base_w1)
  end

  # PRIVATE METHODS

  test "producer_names" do
    expected = "Xilliam Xilliamson and Testy T. Testerson"
    assert_equal expected, subject1.send(:producer_names)
  end

  test "producer_last_names" do
    expected = "Xilliamson and Testerson"
    assert_equal expected, subject1.send(:producer_last_names)
  end
end