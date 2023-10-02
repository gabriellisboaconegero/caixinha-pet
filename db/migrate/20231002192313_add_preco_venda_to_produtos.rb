class AddPrecoVendaToProdutos < ActiveRecord::Migration[7.0]
  def change
    add_column :produtos, :preco_venda, :decimal
  end
end
