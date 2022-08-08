# frozen_string_literal: true

class Card
  attr_reader :value, :suit

  NUMBERS = %w[2 3 4 5 6 7 8 9 10].freeze
  PICTURES = %w[J Q K].freeze
  ACES = %w[A].freeze

  VALUES = NUMBERS + PICTURES + ACES
  SUITS = %w[♣ ♥ ♦ ♠].freeze

  def initialize(value:, suit:)
    @value = value
    @suit = suit
    raise ArgumentError, "Invalid suit: #{suit}" unless valid_suit?(suit)
    raise ArgumentError, "Invalid value: #{value}" unless valid_value?(value)
  end

  # Методы класса
  # Можно вызывать так -- Card.suits и Card.values
  def self.suits
    SUITS
  end

  def self.values
    VALUES
  end

  def to_s
    "#{value}#{suit}"
  end

  def number?
    NUMBERS.include?(value)
  end

  def picture?
    PICTURES.include?(value)
  end

  def ace?
    ACES.include?(value)
  end

  private

  def valid_suit?(suit)
    SUITS.include?(suit)
  end

  def valid_value?(value)
    VALUES.include?(value)
  end
end
