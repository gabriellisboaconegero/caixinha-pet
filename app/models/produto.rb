class Produto < ApplicationRecord
  validates :nome, presence: true
  validates :preco, presence: true
  validates :quantidade, presence: true
  validates :preco_venda, presence: true
end
