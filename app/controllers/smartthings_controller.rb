require 'rest_client'

# links are at ~/Desktop/personal/smarthome_app_links.txt
class SmartthingsController < ApplicationController
  def logs
    log_request = ActiveSupport::JSON.decode(request.body.read).deep_symbolize_keys!
    logger.info log_request
    render :json => { message: "Logs written successfully." }
  end

  def test_endpoint
    render :json => { railsMessage: "This is a test json payload response.",
                      key1: "value1",
                      key2: "value2",
                      key3: {
                          nestedKey1: "nestedValue1",
                          nestedKey2: "nestedValue2"
                      },
                      key4: "value4" }
  end
end
