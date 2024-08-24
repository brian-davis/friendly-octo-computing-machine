class HomeController < ApplicationController
  before_action :set_metrics, only: [:index]

  def index
  end

private

  def set_metrics
    @metrics = BookshelfMetrics.all
  end
end
