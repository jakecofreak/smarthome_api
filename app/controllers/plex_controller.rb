require 'rest-client'

class PlexController < ApplicationController
    
  # hash of approved streaming IPs per user
  @@data = {
      'addietz55c': {
          approved_ips: {
              home: '98.220.134.109'
          },
          friendly_name: 'Aimee/Andrew',
          currently_watching: false
      },
      'dtmob48': {
          approved_ips: {
              home: '68.45.34.102',
              janae_parents: '68.44.183.73'
          },
          friendly_name: 'Janae/Dustin',
          currently_watching: false
      },
      'Rileyhopesuthy': {
          approved_ips: {
              unsure_1: '71.46.94.22',
              home: '73.102.207.11',
              london: '86.150.174.161',
              babysitter_house: '47.227.183.69'
          },
          friendly_name: 'Riley Hope',
          currently_watching: false
      },
      'thejudeallen': {
          approved_ips: {
              home: '184.175.156.31'
          },
          friendly_name: 'Jude',
          currently_watching: false
      },
      'whartman': {
          approved_ips: {
              home: '73.22.188.222'
          },
          friendly_name: 'Jade/Wes',
          currently_watching: false
      },
      'crazynickmarshall': {
          approved_ips: {},
          friendly_name: 'Nicholas',
          currently_watching: false
      },
      'jordannicmarshall': {
          approved_ips: {
              home: '98.223.107.114',
              bryan_uncle_house: '71.194.71.251'
          },
          friendly_name: 'Jordan',
          currently_watching: false
      },
      'paulfanfoot': {
          approved_ips: {
              home: '75.27.16.133'
          },
          friendly_name: 'Mom/Dad',
          currently_watching: false
      },
      'superman724': {
          approved_ips: {
              home: '104.50.254.131',
          },
          friendly_name: 'Maggie/Michael',
          currently_watching: false
      }
  }

  def notify
    # set vars and parse notification payload
    payload = {}
    headers = { :content_type => :json }
    ifttt_url = 'https://maker.ifttt.com/trigger/plex/with/key/bd8RYS8JENBzOlYhHOzxMv'
    notification = ActiveSupport::JSON.decode(request.body.read).deep_symbolize_keys!
    user_id = notification[:user].partition('@').first.to_sym
    user_name = @@data[user_id] ? @@data[user_id][:friendly_name] : "Unknown user #{user_id}"

    # exit early if stream was finished
    if notification[:action] == 'finished'
      payload[:value1] = "#{user_name} has finished watching #{notification[:title]}."
      RestClient.post(ifttt_url, payload.to_json, headers)
      return
    end
    
    # do nothing if watching notification was sent within last 60s
    if @@data[user_id][:currently_watching]
      return
    end

    # matches a user's IP to a location
    location = ''
    @@data[user_id][:approved_ips].each do |key, value|
      if notification[:ipAddress] == value
        location = key.to_s
      end
    end

    # build and send IFTTT notification
    Thread.new do
      @@data[user_id][:currently_watching] = true
      payload[:value1] = "#{user_name} is watching #{notification[:title]}"
      payload[:value2] = location.empty? ? ". Unknown IP #{notification[:ipAddress]} detected!" : " from #{location}."
      payload[:value3] = " Stream count: #{notification[:activeStreams]}"
      RestClient.post(ifttt_url, payload.to_json, headers)
      sleep 60
      @@data[user_id][:currently_watching] = false
    end
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
