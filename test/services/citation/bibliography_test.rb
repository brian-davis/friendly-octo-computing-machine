require "test_helper"
require_relative "citation_test_subjects"

class BibliographyTest < ActiveSupport::TestCase
  include ::CitationTestSubjects

  test "book bibliography entry" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Yu, Charles. _Interior Chinatown_. Pantheon Books, 2020."
    result = Citation::Bibliography.new(book1).entry

    assert_equal expected, result
  end

  test "book bibliography entry multiple authors" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Binder, Amy J., and Jeffrey L. Kidder. _The Channels of Student Activism: How the Left and Right Are Winning (and Losing) in Campus Politics Today_. University of Chicago Press, 2022."

    result = Citation::Bibliography.new(book2).entry

    assert_equal expected, result
  end

  test "book with translator bibliography" do
    expected = "Smith, John. _The Wedding Party_. Translated by Jeremy Tiang. Amazon Crossing, 2021."
    result = Citation::Bibliography.new(book3).entry

    assert_equal(expected, result)
  end

  test "chapter bibliography" do
    expected = "Doyle, Kathleen. “The Queen Mary Psalter.” In _The Book by Design: The Remarkable Story of the World’s Greatest Invention_, edited by P. J. M. Marks and Stephen Parkin. University of Chicago Press, 2023."

    result = Citation::Bibliography.new(book4_child).entry

    assert_equal expected, result
  end

  test "compilation bibiography" do
    expected = "P. J. M. Marks and Stephen Parkin, eds., _The Book by Design: The Remarkable Story of the World’s Greatest Invention_ (University of Chicago Press, 2023)."

    result = Citation::Bibliography.new(book4).entry

    assert_equal expected, result
  end

  # PRIVATE METHODS
  def subject1
    @subject1 ||= Citation::Bibliography.new(base_w1)
  end

  def subject2
    @subject2 ||= Citation::Bibliography.new(base_w2)
  end

  test "alpha_producer_names" do
    expected = "Xilliamson, Xilliam, and Testy T. Testerson"
    assert_equal expected, subject1.send(:alpha_producer_names)
  end

  test "alpha_producer_names fallback to producers" do
    # also test special characters in names
    expected = "Döe, John, and Jane D'Onofrio"
    assert_equal expected, subject2.send(:alpha_producer_names)
  end

  # # DEPRECATED
  # test "improved alpha_producer_names" do
  #   r1 = subject1.send(:_alpha_producer_names)
  #   r2 = subject1.send(:alpha_producer_names)
  #   assert_equal r1, r2
  # end

  # # DEPRECATED
  # test "benchmark improved alpha_producer_names" do
  #   skip("skip benchmarks")

  #   result = Benchmark.bmbm do |x|
  #     x.report("v1: ActiveRecord")   {
  #       subject1.send(:_alpha_producer_names)
  #     }
  #     x.report("v2: Raw SQL")   {
  #       subject1.send(:alpha_producer_names)
  #     }
  #   end
  #   best_result = result.min_by { |r| r.total }.label
  #   puts "best result: #{best_result}"

  #   #                    user       system     total    real
  #   # v1: ActiveRecord   0.000655   0.000045   0.000700 (0.000692)
  #   # v2: Raw SQL        0.000251   0.000041   0.000292 (0.000293)

  #   assert_equal "v2: Raw SQL", best_result
  # end
end