# frozen_string_literal: true

require_relative './game_bank'
require_relative './score_counter'
require_relative './game_party'

class Game
  attr_reader :status # :not_started | :started | :finished

  START_AMOUNT = 100
  BET_AMOUNT = 10

  MAX_SCORE = 21
  MAX_CARDS = 3

  PLAYERS = %i[dealer player].freeze

  def initialize
    @game_bank = GameBank.new
    game_bank.create_account(name: :game, amount: 0)
    game_bank.create_account(name: :dealer, amount: START_AMOUNT)
    game_bank.create_account(name: :player, amount: START_AMOUNT)

    @score_counter = ScoreCounter.new

    @status = :not_started
  end

  def start_party
    raise 'Партия уже начата' if started?

    @status = :started

    # начинаем новую игровую партию на 2х игроков (player, dealer)
    @party = GameParty.new(players: PLAYERS)

    # со счетов игрока и дилера списываем по $10 на игровой счет
    PLAYERS.each do |player|
      transfer(player, :game, BET_AMOUNT)
      party.deal_cards(player: player, cards_count: 2)
    end
  end

  # когда партия закончилась переводим деньги с игрового счета победителю
  def finish_party
    raise 'Нельзя закончить партию пока она не начата' unless started?

    @status = :finished

    payout_to_winner(party_winner)
  end

  def dealer_turn
    raise 'Нельзя сделать ход пока игровая партия не начата' unless started?

    # получить карты
    # посчитать кол-во карт и очков
    # если нужно -- взять одну карту
    dealer_takes_card unless dealer_need_card?
  end

  def player_takes_card
    raise 'Нельзя сделать ход пока игровая партия не начата' unless started?
    raise ArgumentError, "Нельзя выбрать больше #{MAX_CARDS} карт" if player_cards.length >= MAX_CARDS

    party.deal_cards(player: :player, cards_count: 1)
  end

  def party_winner
    raise 'Нельзя узнать победителя пока партия не закончена' unless finished?

    return :dealer if player_score > MAX_SCORE || (dealer_score > player_score && dealer_score <= MAX_SCORE)
    return :player if player_score > dealer_score || dealer_score > MAX_SCORE

    nil # ничья
  end

  def started?
    status == :started
  end

  def finished?
    status == :finished
  end

  def player_cards
    party.cards(:player)
  end

  def player_score
    score_counter.score(cards: player_cards)
  end

  def dealer_cards
    party.cards(:dealer)
  end

  def dealer_score
    score_counter.score(cards: dealer_cards)
  end

  def player_balance
    game_bank.account_amount(name: :player)
  end

  private

  attr_accessor :game_bank, :dealer, :score_counter, :party

  def dealer_takes_card
    party.deal_cards(player: :dealer, cards_count: 1)
  end

  def dealer_need_card?
    dealer_cards.length >= MAX_CARDS || dealer_score >= MAX_SCORE
  end

  def payout_to_winner(winner)
    if winner.nil?
      transfer(:game, :player, BET_AMOUNT)
      transfer(:game, :dealer, BET_AMOUNT)
    else
      transfer(:game, winner, BET_AMOUNT * 2)
    end
  end

  def transfer(from, to, amount)
    game_bank.transfer(from: from, to: to, amount: amount)
  end
end
