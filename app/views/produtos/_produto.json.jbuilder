json.extract! produto, :id, :nome, :quantidade, :preco, :vendidos, :created_at, :updated_at
json.url produto_url(produto, format: :json)
