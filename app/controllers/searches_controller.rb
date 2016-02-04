class SearchesController < ApplicationController
  before_action :set_search, only: [:show]

  # GET /searches
  # GET /searches.json
  def index
    if (params[:search].strip.length <= 1)
      block = Block.find(:height=>params[:search].strip)
    end
    blocks = Block.where(Sequel.like(:blockHash, params[:search].strip + "%")).limit(4)
    transactions = Transaction.where(Sequel.like(:txid, params[:search].strip + "%")).limit(4)
    addresses = Address.where(Sequel.like(:address, params[:search].strip + "%")).limit(5)

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

    if addresses != nil
      addresses.each do |a|
        temp = OpenStruct.new
        temp.type = 'address'
        temp.resHash = a.address
        @results.push(temp)
      end
    end

    if @results.size == 1
      if @results[0].type == 'block'
        unless @results[0].height == 0
          redirect_to("/block/" << @results[0].resHash)
        end
        @results = []
      elsif @results[0].type == 'transaction'
        redirect_to("/tx/" << @results[0].resHash)
      elsif @results[0].type == 'address'
        redirect_to("/address/" << @results[0].resHash)
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
      @search = Search.find!(params[:search].strip)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_params
      params[:search]
    end
end
