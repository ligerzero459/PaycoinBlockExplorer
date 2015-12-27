class BlocksController < ApplicationController
  before_action :set_block, only: [:show]
  helper_method :totalOut, :confirmations, :maxBlocks
  helper_method :getInputAddress

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

  # helpers
  def totalOut(block)
    total = 0.0
    block.transactions.each do |tx|
      total += tx.totalOutput
    end
    total.round(6)
  end

  def confirmations(block)
    Block.where{height >= block.height}.count
  end

  def maxBlocks
    Block.all.count
  end

  def getInputAddress(input)
    puts input.outputTransactionId
    puts input.vout
    Output.where(:transaction_id => input.outputTransactionId, :n => input.vout).get(:address)
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
