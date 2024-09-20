# == Schema Information
#
# Table name: work_producers
#
#  id          :bigint           not null, primary key
#  role        :enum             default("author")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  producer_id :bigint           not null
#  work_id     :bigint           not null
#
# Indexes
#
#  index_work_producers_on_producer_id             (producer_id)
#  index_work_producers_on_role                    (role)
#  index_work_producers_on_work_id                 (work_id)
#  work_producers_work_id_producer_id_role_unique  (work_id,producer_id,role) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (producer_id => producers.id)
#  fk_rails_...  (work_id => works.id)
#
require "test_helper"

class WorkProducerTest < ActiveSupport::TestCase
  test "role enum with prefix methods" do
    subject = fixture_works_the_baltic_origins # save it
    wp1 = subject.work_producers.find_by(role: "author")
    assert wp1.role_author?

    wp2 = subject.work_producers.find_by(role: "translator")
    assert wp2.role_translator?
  end

  test "required references" do
    wp1 = WorkProducer.new(role: :author)
    refute wp1.valid?
    assert_equal ["Work must exist", "Producer must exist"], wp1.errors.full_messages
  end
end
