class HomeController < ApplicationController
  def index
  end

  def append
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
