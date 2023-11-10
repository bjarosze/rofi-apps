# frozen_string_literal: true

require 'json'
require_relative 'menu'

class App
  def initialize(&block)
    @builder = block
    @menus = {}
    @commands = {}
  end

  def run
    instance_eval(&@builder)

    @commands[info['command']].call(info) if info['command']
    @menus[info['next']].draw(info) if info['next']
  end

  def menu(name = 'default', **options, &block)
    @menus[name] = Menu.new(**options, &block)
  end

  def command(name, &block)
    @commands[name] = block
  end

  private

  def info
    return { 'next' => 'default' } unless ENV['ROFI_INFO']

    JSON.parse(ENV['ROFI_INFO'])
  end

  def selected
    ARGV[0]
  end
end
