# == Schema Information
#
# Table name: work_producers
#
#  id          :bigint           not null, primary key
#  work_id     :bigint           not null
#  producer_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  role        :integer
#
require "test_helper"

class WorkProducerTest < ActiveSupport::TestCase
  test "role enum" do
    assert work_producers(:one).role_author?
    assert work_producers(:two).role_editor?
  end

  test "required references" do
    wp1 = WorkProducer.new(role: :author)
    refute wp1.valid?
    assert_equal ["Work must exist", "Producer must exist"], wp1.errors.full_messages
  end
end
