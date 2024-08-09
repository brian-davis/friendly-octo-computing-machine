# == Schema Information
#
# Table name: publishers
#
#  id          :bigint           not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  works_count :integer          default(0)
#
require "test_helper"

class PublisherTest < ActiveSupport::TestCase
  test "works counter_cache" do
    p1 = Publisher.create(name: "Dover")
    assert_equal 0, p1.works.count
    assert_equal 0, p1.works_count
    w1 = p1.works.create({ title: "Math" })
    assert_equal 1, p1.works.count
    assert_equal 1, p1.works_count
    w2 = p1.works.create({ title: "Physics" })
    assert_equal 2, p1.works.count
    assert_equal 2, p1.works_count
    w2.destroy
    p1.reload
    assert_equal 1, p1.works.count
    assert_equal 1, p1.works_count
  end
end
