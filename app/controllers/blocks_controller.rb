class BlocksController < ApplicationController
  helper_method :total_out, :confirmations, :max_blocks
  helper_method :get_input_address, :get_announcements, :block_missing

  # GET /block
  def index
    @blocks = Block.order(:height).reverse.limit(15)
    get_announcements
  end

  # GET /block/{hash}
  def show
    @block = Block.find(:blockHash => params[:id])
  end


  # GET /block-height/{height}
  def show_height
    if params[:id].strip.length <= 7
      @block = Block.find(:height=>params[:id].strip)
      render "show"
    else
      redirect_to("/block/" << params[:id])
    end
  end

  # helpers
  def total_out(block)
    begin
      total = 0.0
      block.transactions.each do |tx|
        total += tx.totalOutput
      end
      total.round(6)
    rescue
      not_found
    end
  end

  def confirmations(block)
    Block.where{height >= block.height}.count
  end

  def max_blocks
    Block.count
  end

  def get_input_address(input)
    puts input.outputTransactionId
    puts input.vout
    Output.where(:transaction_id => input.outputTransactionId, :n => input.vout).get(:address)
  end

  def get_announcements
    @announcements = Announcement.where(:active => true)
    puts @announcements
  end

  def block_missing
    not_found
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
