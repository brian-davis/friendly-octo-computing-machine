class AddCounterCacheToPublishers < ActiveRecord::Migration[7.1]
  def up
    add_column(:publishers, :works_count, :integer, default: 0)
    Publisher.find_each do |publisher|
      Publisher.reset_counters(publisher.id, :works)
    end
  end

  def down
    remove_column(:publishers, :works_count)
  end
end
