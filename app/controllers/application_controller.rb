class ApplicationController < ActionController::Base
  include Turbo::SafeRedirection

  before_action :authenticate_user!
end
