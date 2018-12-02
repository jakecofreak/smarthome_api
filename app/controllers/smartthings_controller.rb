require 'rest_client'

class SmartthingsController < ApplicationController
  def test
    base_url = 'http://172.30.0.106/api/Bo8C0mvSaLK98DbrOkNqdu4c80779GvOsrk2rpuT'
    off_payload = {on: false}.to_json
    json_header = {:content_type => :json}
    # Thread.new do
      response = RestClient.put(base_url + '/groups/4/action', off_payload, json_header)
      # RestClient.put('http://172.30.0.106/api/Bo8C0mvSaLK98DbrOkNqdu4c80779GvOsrk2rpuT/groups/2/action', {on: false})
      # RestClient.put('http://172.30.0.106/api/Bo8C0mvSaLK98DbrOkNqdu4c80779GvOsrk2rpuT/groups/3/action', {on: false})
      # RestClient.put('http://172.30.0.106/api/Bo8C0mvSaLK98DbrOkNqdu4c80779GvOsrk2rpuT/lights/10/state', {on: true, bri: 254})
      # sleep 300
      # RestClient.put('http://172.30.0.106/api/Bo8C0mvSaLK98DbrOkNqdu4c80779GvOsrk2rpuT/lights/10/state', {on: false})
    # end

    # render :json => {message: 'This is a return message'}
    render :json => response
  end
end
