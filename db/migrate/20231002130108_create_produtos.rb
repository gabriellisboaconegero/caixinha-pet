class CreateProdutos < ActiveRecord::Migration[7.0]
  def change
    create_table :produtos do |t|
      t.string :nome
      t.integer :quantidade
      t.decimal :preco
      t.integer :vendidos

      t.timestamps
    end
  end
end
