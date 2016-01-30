class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  helper_method :getInputAddress, :confirmations, :inputSum, :outputSum, :getBlockHeight, :getBlockHash

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
    @transaction =  Transaction.find(:txid => [params[:txid]])
  end

  def confirmations(block_id)
    Block.where{id >= block_id}.count
  end

  def getInputAddress(input)
    Output.where(:transaction_id => input.outputTransactionId, :n => input.vout).get(:address)
  end

  def inputSum(tx)
    Input.where(:transaction_id => tx.id).sum(:value)
  end

  def outputSum(tx)
    Output.where(:transaction_id => tx.id).sum(:value)
  end

  def getBlockHeight(tx)
    Block.where{id >= tx.block_id}.get(:height)
  end

  def getBlockHash(tx)
    Block.where{id >= tx.block_id}.get(:blockHash)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params[:transaction]
    end
end
