class SearchesController < ApplicationController
  before_action :set_search, only: [:show]

  # GET /searches
  # GET /searches.json
  def index
    if params[:search].strip!.length <= 7
      block = Block.find(:height=>params[:search])
    end
    blocks = Block.where(Sequel.like(:blockHash, params[:search] + "%")).limit(4)
    transactions = Transaction.where(Sequel.like(:txid, params[:search] + "%")).limit(4)

    @results = []

    if block != nil
      temp = OpenStruct.new
      temp.type = 'block'
      temp.height = block.height
      temp.resHash = block.blockHash
      @results.push(temp)
    end

    if blocks != nil
      blocks.each do |b|
        temp = OpenStruct.new
        temp.type = 'block'
        temp.height = b.height
        temp.resHash = b.blockHash
        @results.push(temp)
      end
    end

    if transactions != nil
      transactions.each do |tx|
        temp = OpenStruct.new
        temp.type = 'transaction'
        temp.resHash = tx.txid
        @results.push(temp)
      end
    end

    if @results.size == 1
      if @results[0].type == 'block'
        redirect_to("/blocks/" << @results[0].height.to_s)
      elsif @results[0].type == 'transaction'
        redirect_to("/tx/" << @results[0].resHash)
      end
    end
  end

  # GET /searches/1
  # GET /searches/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search
      @search = Search.find!(params[:search])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_params
      params[:search]
    end
end
