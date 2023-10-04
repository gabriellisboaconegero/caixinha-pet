class VendaController < ApplicationController
  before_action :set_produto, only: %i[vender index]
  def index
    render :index
  end

  def vender
    vendidos = prod_vendidos.to_i
    try_venda(vendidos, @produto) || return

    @produto.quantidade -= vendidos
    @produto.vendidos += vendidos
    respond_to do |format|
      if @produto.save
        format.html { redirect_to produto_url(@produto), notice: "Foram vendidas #{vendidos} #{@produto.nome} por #{vendidos * @produto.preco_venda}." }
        format.json { render show_produto_path(@produto), status: :ok, location: @produto }
      else
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @produto.errors, status: :unprocessable_entity }
      end
    end

  end

  private

  def try_venda(vendidos, produto)
    if vendidos > produto.quantidade
      respond_to do |format|
        produto.errors.add :base, "Tentou vender #{vendidos} e tem #{@produto.quantidade}!!"
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @produto.errors, status: :unprocessable_entity }
      end

      return false
    end

    true
  end

  def set_produto
    @produto = Produto.find(params[:produto_id])
  end

  def prod_vendidos
    a = params.require(:produto).permit(:vendidos)['vendidos']
    print a
    a
  end
end
