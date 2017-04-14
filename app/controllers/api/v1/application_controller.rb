module Api
  class InvalidRequest < ::StandardError; end

  module V1
    class ApplicationController < ActionController::Base

      # rescue_from Exception, with: :catch_exception if Rails.env.production?
      before_filter :cors_preflight_check
      after_filter :cors_set_access_control_headers
      def cors_set_access_control_headers
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
        headers['Access-Control-Max-Age'] = '1728000'
      end
      def cors_preflight_check
        if request.method == 'OPTIONS'
          headers['Access-Control-Allow-Origin'] = '*'
          headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
          headers['Access-Control-Request-Method'] = '*'
          headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
          headers['Access-Control-Max-Age'] = '1728000'
          render :text => '', :content_type => 'text/plain'
        end
      end
      
    end
 end
end
