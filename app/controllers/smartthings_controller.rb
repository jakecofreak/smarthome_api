require 'rest_client'

# links are at ~/Desktop/personal/smarthome_app_links.txt
class SmartthingsController < ApplicationController
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

  end
end
