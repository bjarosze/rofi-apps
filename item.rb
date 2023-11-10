# frozen_string_literal: true

class Item
  OPTIONS = %i[icon meta nonselectable].freeze

  attr_reader :active, :urgent

  def initialize(name, **options)
    @name = name
    @options = options
    @active = options.fetch(:active, false)
    @urgent = options.fetch(:urgent, false)
  end

  def draw
    puts "#{@name}#{draw_options}#{draw_info}"
  end

  private

  def draw_options
    @options.slice(*OPTIONS).inject([]) do |result, (name, value)|
      result << "\0#{name}\x1f#{value}"
    end.join
  end

  def draw_info
    info = @options.except(*OPTIONS)
    "\0info\x1f#{info.to_json}"
  end
end
