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

      'ccmovies7': {
          approved_ips: {},
          friendly_name: 'Crystal',
          currently_watching: false
      },
      'crazynickmarshall': {
          approved_ips: {},
          friendly_name: 'Nicholas',
          currently_watching: false
      },
      'Ddietz1': {
          approved_ips: {
              SC: '67.20.136.88',
              corys: '173.95.12.131',
              home: '172.98.129.236'
          },
          friendly_name: 'David',
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
      'gdietz57': {
          approved_ips: {
              home: '67.20.136.88'
          },
          friendly_name: 'Gammy',
          currently_watching: false
      },
      'hillc913': {
          approved_ips: {
              home: '73.45.234.137',
              idiots_place: '50.76.88.4'
          },
          friendly_name: 'Hill Clark',
          currently_watching: false
      },
      'jordannicmarshall': {
          approved_ips: {
              home: '98.223.107.114',
              reids_house: '162.221.221.186',
              bryan_uncle_house: '71.194.71.251'
          },
          friendly_name: 'Jordan',
          currently_watching: false
      },
      'kelan.larkin': {
          approved_ips: {
              home: '47.227.174.164'
          },
          friendly_name: 'Kelan',
          currently_watching: false
      },
      'mbchyno': {
          approved_ips: {
              home: '208.38.246.66'
          },
          friendly_name: 'Marie',
          currently_watching: false
      },
      'motz914': {
          approved_ips: {
              school: '69.174.173.131',
              home: '68.57.195.104'
          },
          friendly_name: 'Scott Motz',
          currently_watching: false
      },
      'paulfanfoot': {
          approved_ips: {
              home: '75.27.16.133'
          },
          friendly_name: 'Mom/Dad',
          currently_watching: false
      },
      'tamie_ellis': {
          approved_ips: {
              home: '208.38.246.30',
              home2: '208.38.246.40',
              home3: '208.38.246.113',
              home4: '208.38.246.6'
          },
          friendly_name: 'Tamie',
          currently_watching: false
      },
      'thejudeallen': {
          approved_ips: {
              home: '184.175.156.31',
              memphis: '73.59.145.149',
              nashville: '71.203.212.55',
              north_carolina: '75.110.111.135'
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
      }
  }

  def notify
    # set vars and parse notification payload
    payload = {}
    headers = { :content_type => :json }
    ifttt_url = 'https://maker.ifttt.com/trigger/plex/with/key/bd8RYS8JENBzOlYhHOzxMv'
    notification = ActiveSupport::JSON.decode(request.body.read).deep_symbolize_keys!
    user_id = notification[:user].partition('@').first.to_sym
    if @@data[user_id].nil?
      @@data[user_id] = {
          approved_ips: {
              unknown_location: notification[:ipAddress]
          },
          friendly_name: "Unknown user #{user_id}",
          currently_watching: false
      }
    end
    user_name = @@data[user_id][:friendly_name]

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
      if @@data[user_id][:friendly_name].include? "Unknown"
        @@data.delete user_id
      else
        @@data[user_id][:currently_watching] = false
      end
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
