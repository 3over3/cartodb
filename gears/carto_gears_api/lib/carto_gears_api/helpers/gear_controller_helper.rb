require_dependency 'carto_gears_api/helpers/url_helper'
require_dependency 'carto_gears_api/users/users_service'

module CartoGearsApi
  module Helpers
    # This should be included in every controller using the following CARTO layouts:
    # - carto_gears_api/dashboard
    # - carto_gears_api/profile
    module GearControllerHelper
      include SafeJsObject
      include CartoDB::ConfigUtils
      include TrackjsHelper
      include GoogleAnalyticsHelper
      include HubspotHelper
      include FrontendConfigHelper
      include AppAssetsHelper
      include MapsApiHelper
      include SqlApiHelper
      include CartoGearsApi::Helpers::UrlHelper
      include CartoGearsApi::Helpers::PagesHelper

      # @return [CartoGearsApi::Users::User] Logged user, `nil` if none.
      def logged_user
        @logged_user ||= CartoGearsApi::Users::UsersService.new.logged_user(request)
      end
    end
  end
end
