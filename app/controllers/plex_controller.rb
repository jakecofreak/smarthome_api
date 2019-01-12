require 'rest-client'

class PlexController < ApplicationController
  def notify
    # set vars and parse notification payload
    payload = {}
    headers = { :content_type => :json }
    ifttt_url = 'https://maker.ifttt.com/trigger/plex/with/key/bd8RYS8JENBzOlYhHOzxMv'
    notification = ActiveSupport::JSON.decode(request.body.read).deep_symbolize_keys!
    user = notification[:user].partition('@').first.to_sym

    # exit early if stream was finished
    if notification[:action] == 'finished'
      payload[:value1] = "#{user} has finished watching #{notification[:title]}."
      RestClient.post(ifttt_url, payload.to_json, headers)
      return
    end

    # hash of approved streaming IPs per user
    approved_ips = {
        'addietz55c': {
            home: '98.220.134.109'
        },
        'dtmob48': {
            home: '68.45.34.102'
        },
        'Rileyhopesuthy': {
            home: '71.46.94.22'
        },
        'thejudeallen': {
            home: '184.175.156.31'
        },
        'whartman': {
            home: '73.22.188.222'
        },
        'crazynickmarshall': {},
        'jordannicmarshall': {
            home: '98.223.107.114',
            bryan_uncle_house: '71.194.71.251'
        },
        'paulfanfoot': {}
    }

    # matches a user's IP to a location
    location = ''
    approved_ips[user].each do |key, value|
      if notification[:ipAddress] == value
        location = key.to_s
      end
    end

    # build and send IFTTT notification
    payload[:value1] = "#{user} #{notification[:action]} watching #{notification[:title]}"
    payload[:value2] = location.empty? ? ". Unknown IP #{notification[:ipAddress]} detected!" : " from #{location}."
    payload[:value3] = " Stream count: #{notification[:activeStreams]}"
    RestClient.post(ifttt_url, payload.to_json, headers)
  end

  ## REQUEST PAYLOAD RECEIVED FROM TAUTULLI ###
  # {
  #     "action": {action},
  #     "activeStreams": {streams},
  #     "user": {user},
  #     "device": {device},
  #     "platform": {platform},
  #     "product": {product},
  #     "player": {player},
  #     "ipAddress": {ip_address},
  #     "quality": {quality_profile},
  #     "bandwidth": {stream_bandwidth},
  #     "mediaType": {media_type},
  #     "title": {title}
  # }
end