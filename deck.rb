# frozen_string_literal: true

require_relative './card'

class Deck
  def initialize
    # при создании инициализируется массив из 52 карт
    @cards = create_cards.shuffle
  end

  def take(cards_count = 1)
    raise ArgumentError, 'Недостаточно карт в колоде' unless count.positive?

    @cards.shift(cards_count)
  end

  def count
    cards.count
  end

  private

  attr_reader :cards

  def create_cards
    cards = []
    Card.values.each do |value|
      Card.suits.each do |suit|
        cards << Card.new(value: value, suit: suit)
      end
    end
    cards
  end
end
