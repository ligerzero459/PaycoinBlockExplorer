class RichListsController < ApplicationController

  # GET /rich_lists
  # GET /rich_lists.json
  def index
    if params[:limit] == nil
      @rich_lists = Address.order(:balance).reverse.limit(25)
    else
      @rich_lists = Address.order(:balance).limit(params[:limit])
    end

    @outstanding = OutstandingCoin.order(:coinSupply).limit(1)
    @outstanding = @outstanding.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rich_list
      @rich_list = RichList.find!(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rich_list_params
      params[:rich_list]
    end
end
