# frozen_string_literal: true

require_relative 'app'

app = App.new do
  menu(prompt: 'Choose Audio Device') do
    sinks = JSON.parse(`pactl -f json list sinks`)
    sources = JSON.parse(`pactl -f json list sources`)
    pa_info = JSON.parse(`pactl -f json info`)

    sinks.each do |sink|
      item(
        " #{sink['description']}",
        sink_name: sink['name'],
        command: 'change_sink',
        active: pa_info['default_sink_name'] == sink['name']
      )
    end

    sources.each do |source|
      item(
        " #{source['description']}",
        source_name: source['name'],
        command: 'change_source',
        active: pa_info['default_source_name'] == source['name']
      )
    end

    item('--------------', nonselectable: true)
    item('Profiles', next: 'cards')
  end

  menu('cards', prompt: 'Choose Card') do
    cards = JSON.parse(`pactl -f json list cards`)
    cards.each do |card|
      item(
        card['properties']['device.description'],
        card_name: card['name'],
        next: 'profiles'
      )
    end
  end

  menu('profiles', prompt: 'Choose Profile') do |info|
    cards = JSON.parse(`pactl -f json list cards`)
    selected_card = cards.find { |card| card['name'] == info['card_name'] }

    selected_card['profiles'].each do |name, profile|
      next unless profile['available']

      item(
        profile['description'],
        profile_name: name,
        card_name: info['card_name'],
        command: 'change_profile',
        active: selected_card['active_profile'] == name
      )
    end
  end

  command('change_sink') do |info|
    `pactl set-default-sink #{info['sink_name']}`
  end

  command('change_source') do |info|
    `pactl set-default-source #{info['source_name']}`
  end

  command('change_profile') do |info|
    `pactl set-card-profile #{info['card_name']} #{info['profile_name']}`
  end
end

app.run
