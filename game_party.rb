# frozen_string_literal: true

require_relative './deck'

class GameParty
  attr_reader :players

  def initialize(players: %i[player dealer])
    @deck = Deck.new
    @players = players

    @player_cards = {}
    initialize_player_cards
  end

  def deal_cards(player:, cards_count: 1)
    cards = deck.take(cards_count)
    player_cards[player] += cards
  end

  def cards(player)
    player_cards[player]
  end

  private

  attr_reader :deck, :player_cards

  # для каждого игрока создаем пустой массив карт
  # { player1 => [], player2 => [], ... }
  def initialize_player_cards
    players.each do |player|
      player_cards[player] = []
    end
  end
end
