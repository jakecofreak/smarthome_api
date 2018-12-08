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
    response = ActiveSupport::JSON.decode(request.body.read)

    if response["lifecycle"] == "PING"
      render :json => { pingData: response["pingData"] }
    end
    # render :json => { message: 'this is a message'}
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
