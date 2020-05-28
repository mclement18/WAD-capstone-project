class ApplicationJob < ActiveJob::Base
  include Rails.application.routes.url_helpers

  def default_url_options
    { locale: I18n.locale }
  end
end
