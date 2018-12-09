require 'rest_client'

# links are at ~/Desktop/personal/smarthome_app_links.txt
class SmartthingsController < ApplicationController
  def logs
    log_request = ActiveSupport::JSON.decode(request.body.read).deep_symbolize_keys!
    logger.info log_request
    render :json => { message: "Logs written successfully." }
  end
end
