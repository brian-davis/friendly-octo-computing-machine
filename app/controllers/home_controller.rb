class HomeController < ApplicationController
  before_action :set_metrics, only: [:index]

  def index
  end

private

  def set_metrics
    @summary = BookshelfMetrics.summary
    @chart_usage = BookshelfMetrics.chart_usage(params["period"].presence, 200)
  end
end
