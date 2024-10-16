class WorkFilter
  class << self
    alias_method :[], def call(params)
      works_results = if params["tag"] == "untagged"
        Work.untagged
      elsif params["tag"].in?(Work.all_tags)
        Work.all.with_any_tags([params["tag"]])
      elsif params["tag"] == "all" || params["tag"].blank?
        Work.all
      else
        # ?tag=malicious
        Work.none
      end

      acc_param = params["accession"]
      valid_accession_params = ["collection", "wishlist"]
      if acc_param.in?(valid_accession_params)
        works_results = works_results.send(acc_param)
      end

      status_param = params["sts"]
      valid_status_params = ["read", "unread"]
      if status_param.in?(valid_status_params)
        works_results = works_results.send(status_param)
      end

      # filter by search term
      if params["search_term"].present?
        term = ActiveRecord::Base::sanitize_sql(params["search_term"])
        works_results = works_results.search_title(term).unscope(:order)
      end

      format_param = params["frmt"]
      valid_formats = Work.publishing_formats.keys
      if format_param.in?(valid_formats)
        works_results = works_results.send("publishing_format_#{format_param}")
      end

      lang_param = params["lang"]
      if lang_param.in?(Work.language_options(unspecified: true))
        works_results = if lang_param == "[unspecified]"
          works_results.where(language: nil)
        else
          works_results.where(language: lang_param)
        end
      end

      # order by dropdown selection
      valid_order_params = ["title", "year", "rating"]
      valid_dir_params = ["asc", "desc"]
      order_param = params["order"].presence
      dir_param = params["dir"].presence

      order_arg = (valid_order_params & [order_param])[0] || "title"
      dir_arg = ((valid_dir_params & [dir_param])[0] || "asc").upcase
      order_arg = if order_arg == "rating" && dir_arg == "DESC"
        # always put nil at end
        "COALESCE(works.rating, -1)"
      elsif order_arg == "rating" && dir_arg == "ASC"
        # always put nil at end
        "COALESCE(works.rating, 9999999)"
      elsif order_arg == "year" && dir_arg == "DESC"
        # always put nil at end
        "COALESCE(works.year_of_composition, works.year_of_publication, -9999)"
      elsif order_arg == "year" && dir_arg == "ASC"
        # always put nil at end
        "COALESCE(works.year_of_composition, works.year_of_publication, 9999)"
      elsif order_arg == "title"
        "UPPER(works.title)"
      else
        order_arg
      end

      order_param = "#{order_arg} #{dir_arg.upcase}"
      order_params = [order_param]
      order_params << "UPPER(works.title) ASC" unless order_arg == "UPPER(works.title)" # secondary ordering
      order_params = order_params.uniq.join(", ") # secondary ordering

      # bullet disabled here
      works_results.order(Arel.sql(order_params)).includes(:parent).includes(work_producers: :producer).includes(:producers)
    end
  end
end