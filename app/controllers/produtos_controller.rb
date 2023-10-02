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
  def edit; end

  # POST /produtos or /produtos.json
  def create
    @produto = Produto.new(produto_params) do |p|
      p.preco = produto_params['preco'].to_d / produto_params['quantidade'].to_i
      p.vendidos = 0
    end

    respond_to do |format|
      if @produto.save
        format.html { redirect_to produto_url(@produto), notice: 'Produto was successfully created.' }
        format.json { render :show, status: :created, location: @produto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /produtos/1 or /produtos/1.json
  def update
    vendidos = produto_params['vendidos'].to_i
    # verificar se tem, mas ainda não sei como fazer
    @produto.quantidade -= vendidos
    @produto.vendidos += vendidos
    respond_to do |format|
      if @produto.save
        format.html { redirect_to produto_url(@produto), notice: "Foram vendidas #{vendidos} #{@produto.nome}." }
        format.json { render :show, status: :ok, location: @produto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @produto.errors, status: :unprocessable_entity }
      end
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
      params.require(:produto).permit(:nome, :quantidade, :preco, :vendidos)
    end
end
