# frozen_string_literal: true

require_relative './card'

class ScoreCounter
  def score(cards:)
    numbers = cards.select(&:number?)
    pictures = cards.select(&:picture?)
    aces = cards.select(&:ace?)

    score_without_aces = score_numbers(numbers) + score_pictures(pictures)
    score_for_aces = score_aces(aces, score_without_aces)

    score_without_aces + score_for_aces
  end

  private

  def score_numbers(numbers)
    numbers.sum { |card| card.value.to_i }
  end

  def score_pictures(pictures)
    pictures.count * 10
  end

  # 1. кол-во очков для тузов зависит от общего кол-ва очков для всех переданных карт
  # 2. если тузов больше одного, то в любом случае только один туз может быть 11 если позволяет общая сумма очков
  def score_aces(aces, score_without_aces)
    aces_count = aces.count
    return 0 if aces_count.zero?

    if score_without_aces + aces_count <= 11
      # можем посчитать один туз как 11,
      # остальные тузы -- по одному очку
      11 + aces_count - 1
    else
      # считаем все тузы по 1 очку
      aces_count
    end
  end
end
