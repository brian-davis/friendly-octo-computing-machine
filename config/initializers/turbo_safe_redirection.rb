# https://github.com/hotwired/turbo-rails/issues/259#issuecomment-1013852530

# frozen_string_literal: true

module Turbo
  module SafeRedirection
    extend ActiveSupport::Concern

    def redirect_to(url = {}, options = {})
      Rails.logger.debug { "Turbo::SafeRedirection#redirect_to" }
      result = super

      if !request.get? && options[:turbo] != false && request.accepts.include?(Mime[:turbo_stream])
        self.status = 303
      end

      result
    end
  end
end