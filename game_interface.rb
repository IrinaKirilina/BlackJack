# frozen_string_literal: true

require_relative './game'

class GameInterface
  ACTIONS = [
    '1 - пропустить ход',
    '2 - взять карту',
    '3 - открыть карты'
  ].freeze

  def start_game
    @game = Game.new

    puts 'Как вас зовут? '
    player_name = gets.chomp
    puts "Привет, #{player_name}! Начинаем игру!"

    loop do # игра
      game.start_party
      loop do # партия
        display_cards
        display_player_balance

        continue_party = player_turn
        unless continue_party
          game.finish_party
          break
        end

        dealer_turn
      end

      display_cards(show_dealer_cards: true)
      display_winner

      puts 'Закончить игру? (1-Закончить)'
      finish_game = gets.chomp.to_i
      break if finish_game == 1
    end
  end

  private

  attr_reader :game

  def player_turn
    puts 'Bыберите действие:'
    puts ACTIONS
    player_action = gets.chomp.to_i

    case player_action
    when 1
      # просто пропускаем ход
      true # продолжаем партию
    when 2
      game.player_takes_card
      true # продолжаем партию
    when 3
      false # заканчиваем партию
    end
  end

  def dealer_turn
    game.dealer_turn
  end

  def display_cards(show_dealer_cards: false)
    puts "Сумма очков: #{game.player_score}"
    puts "Ваши карты: #{game.player_cards.map(&:to_s)}"

    if show_dealer_cards
      puts "Сумма очков дилера: #{game.dealer_score}"
      dealer_cards = game.dealer_cards.map(&:to_s)
    else
      dealer_cards = '*' * game.dealer_cards.count
    end
    puts "Карты дилера: #{dealer_cards}"
  end

  def display_player_balance
    puts "Баланс: $#{game.player_balance}"
  end

  def display_winner
    case game.party_winner
    when :player
      puts 'Вы выиграли партию!'
    when :dealer
      puts 'Дилер выиграл партию'
    else
      puts 'Ничья!'
    end
  end
end
