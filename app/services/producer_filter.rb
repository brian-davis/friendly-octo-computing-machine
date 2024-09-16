class ProducerFilter
  class << self
    alias_method :[], def call(params)
      producer_results = Producer.all

      # filter by search term
      if params["search_term"].present?
        term = ActiveRecord::Base::sanitize_sql(params["search_term"])
        producer_results = producer_results.search_name(term).unscope(:order)
      end
      # order by dropdown selection
      valid_order_params = ["full_name", "works_count"]
      valid_dir_params = ["asc", "desc"]

      order_param = params["order"].presence
      order_arg = (valid_order_params & [order_param])[0]

      dir_param = params["dir"].presence
      dir_arg = (valid_dir_params & [dir_param])[0] || :asc

      default_query_options = {
        :full_name => :asc
      }
      new_query_options = {}
      new_query_options[order_arg.to_sym] = dir_arg.to_sym if order_arg

      query_options = default_query_options.merge(new_query_options)

      producer_results.order_by_full_name(query_options) 
    end
  end
end