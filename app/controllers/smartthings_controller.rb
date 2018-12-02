require 'rest_client'

class SmartthingsController < ApplicationController
  def test
    # Thread.new do
      RestClient.put('http://172.30.0.50/api/Bo8C0mvSaLK98DbrOkNqdu4c80779GvOsrk2rpuT/groups/4/action', {on: false})
      RestClient.put('http://172.30.0.50/api/Bo8C0mvSaLK98DbrOkNqdu4c80779GvOsrk2rpuT/groups/2/action', {on: false})
      RestClient.put('http://172.30.0.50/api/Bo8C0mvSaLK98DbrOkNqdu4c80779GvOsrk2rpuT/groups/3/action', {on: false})
      # RestClient.put('http://172.30.0.106/api/Bo8C0mvSaLK98DbrOkNqdu4c80779GvOsrk2rpuT/lights/10/state', {on: true, bri: 254})
      # sleep 300
      # RestClient.put('http://172.30.0.106/api/Bo8C0mvSaLK98DbrOkNqdu4c80779GvOsrk2rpuT/lights/10/state', {on: false})
    # end

    render :json => {message: 'This is a return message'}
  end
end
