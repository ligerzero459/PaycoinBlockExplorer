class SearchesController < ApplicationController
  before_action :set_search, only: [:show, :edit]

  # GET /searches
  # GET /searches.json
  def index
    @block = Block.find(:height=>params[:search])
    @block = Block.where(Sequel.like(:blockHash, :))
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
