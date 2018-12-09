require 'rest_client'

# links are at ~/Desktop/personal/smarthome_app_links.txt
class SmartthingsController < ApplicationController
  def root
    render :json => { message: 'This is the root of the application.' }
  end

  def logs
    log_request = ActiveSupport::JSON.decode(request.body.read).deep_symbolize_keys!
    logger.info log_request
  end

  def leaving
    base_url = 'http://172.30.0.106/api/Bo8C0mvSaLK98DbrOkNqdu4c80779GvOsrk2rpuT'
    off_payload = {on: false}.to_json
    json_header = {:content_type => :json}

    Thread.new do
      RestClient.put(base_url + '/groups/4/action', off_payload, json_header)
      RestClient.put(base_url + '/groups/2/action', off_payload, json_header)
      RestClient.put(base_url + '/groups/3/action', off_payload, json_header)
      RestClient.put(base_url + '/lights/10/state', {on: true, bri: 254}.to_json, json_header)
      sleep 300
      RestClient.put(base_url + '/lights/10/state', off_payload, json_header)
    end
  end

  # SmartThings lifecycle integration
  def lifecycle
    lifecycle_request = ActiveSupport::JSON.decode(request.body.read).deep_symbolize_keys!
    case lifecycle_request[:lifecycle]
      when "PING"
        # respond with pingData object for PINGs
        render :json => { pingData: lifecycle_request[:pingData] }

      when "CONFIGURATION"
        # respond with appropriate config data for CONFIGURATION
        case lifecycle_request[:configurationData][:phase]
          when "INITIALIZE"
            response_payload = {
                configurationData: {
                    initialize: {
                        name: "Smart Home Brain",
                        description: "Ruby app for managing all event data from SmartThings",
                        id: "smarthome-brain-api",
                        permissions: %w(r:installedapps:* w:installedapps:* l:devices r:devices:* w:devices:* x:devices:* i:deviceprofiles r:schedules w:schedules r:locations:*),
                        firstPageId: "1"
                    }
                }
            }
          render :json => response_payload

          when "PAGE"
            response_payload = {
                configurationData: {
                    page: {
                        pageId: "1",
                        name: "No configuration needed.",
                        nextPageId: nil,
                        previousPageId: nil,
                        complete: true,
                        sections: [
                            {
                                name: "Configuration",
                                settings: [
                                    {
                                        id: "paragraphInformation",
                                        name: "You're all set!",
                                        description: "No configuration needed.",
                                        type: "PARAGRAPH",
                                        defaultValue: "There is no further configuration needed for this app."
                                    }
                                ]
                            }
                        ]
                    }
                }
            }
          render :json => response_payload

          else
            render :json => { message: "DID NOT FIND INITIALIZE OR PAGE", configPhase: lifecycle_request[:configurationData][:phase] }
        end
      else
        render :json => { message: "DID NOT FIND CONFIGURATION" }
    end
  end

  def garage_on
    RestClient.put('http://98.220.134.109:8086/api/Bo8C0mvSaLK98DbrOkNqdu4c80779GvOsrk2rpuT/lights/10/state',
                   { on: true, bri: 254 }.to_json, { :content_type => :json })
  end

  def garage_off
    RestClient.put('http://98.220.134.109:8086/api/Bo8C0mvSaLK98DbrOkNqdu4c80779GvOsrk2rpuT/lights/10/state',
                   { on: false }.to_json, { :content_type => :json })
  end
end
