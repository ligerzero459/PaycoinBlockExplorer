class BlocksController < ApplicationController
  helper_method :totalOut, :confirmations, :maxBlocks
  helper_method :getInputAddress

  # GET /blocks
  def index
    @blocks = Block.order(:height).reverse.limit(30)
  end

  # GET /blocks/{hash}
  def show
    @block = Block.find(:blockHash => params[:id])
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
    Block.count
  end

  def getInputAddress(input)
    puts input.outputTransactionId
    puts input.vout
    Output.where(:transaction_id => input.outputTransactionId, :n => input.vout).get(:address)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_block
      @block = Block.find(:blockHash=>params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def block_params
      params[:block]
    end
end
