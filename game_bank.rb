# frozen_string_literal: true

class GameBank
  def initialize
    @accounts = {}
  end

  # 1. может создавать именованный счёт у которого   указывается название и начальная сумма
  # можно просто в виде хэша хранить { имя счета => сумма }
  # create_account(name:, amount: 0)
  # добавить проверку, что счета с таким именем еще нет
  def create_account(name:, amount: 0)
    raise ArgumentError, 'Cчет с таким именем уже существует' if accounts.key?(name)

    accounts[name] = amount
  end

  # 2. может переводить деньги с одного счета на другой с указанием названия счетов и суммы перевода
  # Если счет не найден по имени, то выдает ошибку
  # Если денег на счету меньше чем требуется перевести, выдает ошибку
  # transfer(from:, to:, amount:)
  def transfer(from:, to:, amount:)
    raise ArgumentError, 'Счет-отправитель не найден' unless accounts.key?(from)
    raise ArgumentError, 'Счет-получатель не найден' unless accounts.key?(to)
    raise ArgumentError, 'Недостаточно денег на счете' if accounts[from] < amount

    accounts[from] -= amount
    accounts[to] += amount
  end

  # 3. возвращает остаток на счете
  def account_amount(name:)
    accounts[name]
  end

  private

  attr_reader :accounts
end
