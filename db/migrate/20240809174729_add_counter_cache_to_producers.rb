class AddCounterCacheToProducers < ActiveRecord::Migration[7.1]
  def up
    add_column(:producers, :works_count, :integer, default: 0)
    Producer.find_each do |producer|
      Producer.reset_counters(producer.id, :works)
    end
  end

  def down
    remove_column(:producers, :works_count)
  end
end
