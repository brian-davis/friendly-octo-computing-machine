class HomeController < ApplicationController
  before_action :set_metrics, only: [:index]

  def index
  end

private

  def set_metrics
    @summary = BookshelfMetrics.summary
    
    if Flipper.enabled?(:reading_sessions)
      @chart_usage = BookshelfMetrics.chart_usage(params["period"].presence, 200)
    end
  end
end
