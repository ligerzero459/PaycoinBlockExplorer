class BlocksController < ApplicationController
  before_action :set_block, only: [:show, :edit, :update, :destroy]

  # GET /blocks
  # GET /blocks.json
  def index
    @blocks = Block.order(:height).reverse.limit(20)
  end

  # GET /blocks/1
  # GET /blocks/1.json
  def show
    @block = Block.find(:height => [params[:id]])
  end

  # GET /blocks/new
  def new
    @block = Block.new
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_block
      @block = Block.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def block_params
      params[:block]
    end
end
