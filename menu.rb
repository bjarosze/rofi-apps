# frozen_string_literal: true

require_relative 'item'

class Menu
  def initialize(**options, &block)
    @items = []
    @builder = block
    @options = options
  end

  def draw(info)
    instance_exec(info, &@builder)
    draw_options
    draw_active
    @items.each(&:draw)
  end

  def item(name, **options)
    @items << Item.new(name, **options)
  end

  private

  def draw_options
    @options.each do |name, value|
      puts "\0#{name}\x1f#{value}"
    end
  end

  def draw_active
    active_indexes = @items.each_with_object([]).with_index do |(item, acc), index|
      acc << index if item.active
    end

    puts "\0active\x1f#{active_indexes.join(',')}"
  end
end
