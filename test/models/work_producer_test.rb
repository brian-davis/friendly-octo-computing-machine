# == Schema Information
#
# Table name: work_producers
#
#  id          :bigint           not null, primary key
#  role        :integer          default(0)
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
