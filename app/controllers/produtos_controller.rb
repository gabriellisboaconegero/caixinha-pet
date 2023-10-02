class ProdutosController < ApplicationController
  # Executa metodo  set_produto antes das ações show, edit, update e destroy
  before_action :set_produto, only: %i[ show edit update destroy ]

  # GET /produtos or /produtos.json
  def index
    @produtos = Produto.all
  end

  # GET /produtos/1 or /produtos/1.json
  def show; end

  # GET /produtos/new
  def new
    @produto = Produto.new
  end

  # GET /produtos/1/edit
  def edit
    @type = params["edit_type"]
  end

  # POST /produtos or /produtos.json
  def create
    @produto = Produto.new(produto_params) do |p|
      p.preco = produto_params['preco'].to_d / produto_params['quantidade'].to_i
      p.preco = p.preco.round(2)
      p.vendidos = 0
    end

    respond_to do |format|
      if @produto.save
        format.html { redirect_to produto_url(@produto), notice: "Produto #{@produto.nome} criado" }
        format.json { render :show, status: :created, location: @produto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /produtos/1 or /produtos/1.json
  def update
    if params['produto']['type'] == 'vender'
      vender
    elsif params['produto']['type'] == 'adicionar'
      adicionar
    end
  end

  # DELETE /produtos/1 or /produtos/1.json
  def destroy
    @produto.destroy

    respond_to do |format|
      format.html { redirect_to produtos_url, notice: "Produto was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_produto
    @produto = Produto.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def produto_params
    params.require(:produto).permit(:nome, :quantidade, :preco, :vendidos, :preco_venda)
  end

  def vender
    vendidos = produto_params['vendidos'].to_i
    if vendidos > @produto.quantidade
      respond_to do |format|
        @produto.errors.add :base, "Tentou vender #{vendidos} e tem #{@produto.quantidade}!!"
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @produto.errors, status: :unprocessable_entity }
      end

      return
    end
    @produto.quantidade -= vendidos
    @produto.vendidos += vendidos
    respond_to do |format|
      if @produto.save
        format.html { redirect_to produto_url(@produto), notice: "Foram vendidas #{vendidos} #{@produto.nome} por #{vendidos * @produto.preco_venda}." }
        format.json { render :show, status: :ok, location: @produto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @produto.errors, status: :unprocessable_entity }
      end
    end
  end

  def adicionar
    adicionados = produto_params['quantidade'].to_i
    @produto.quantidade += adicionados
    respond_to do |format|
      if @produto.save
        format.html { redirect_to produto_url(@produto), notice: "Foram adicionados #{adicionados} #{@produto.nome}." }
        format.json { render :show, status: :ok, location: @produto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @produto.errors, status: :unprocessable_entity }
      end
    end
  end
end
