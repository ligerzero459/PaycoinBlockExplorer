class AddressesController < ApplicationController
  helper_method :generate_qr_code, :address_confirmations, :block_find

  # GET /addresses
  # GET /addresses.json
  def index
    @addresses = Address.all
  end

  # GET /addresses/1
  # GET /addresses/1.json
  def show
    if params[:limit] == nil
      limit = 30
    elsif params[:limit].downcase == 'all'
      limit = 100000;
    else
      params[:limit] = params[:limit].to_i
      if params[:limit] == 0
        limit = 30
      else
        limit = params[:limit]
      end
    end
    temp = OpenStruct.new
    temp.address = Address.find(:address => params[:address])
    @ledger = Ledger.join(:transactions, :txid=>:txid)
                  .join(:blocks, :id=>:transactions__block_id)
                  .select(:ledger__id, :blocks__blockHash, :blocks__height, :ledger__txid, :ledger__address, :ledger__type)
                  .select_append{sum(:ledger__value).as(value)}
                  .select_append{max(:ledger__balance).as(balance)}
                  .where(:ledger__address => params[:address])
                  .group(:ledger__txid, :ledger__type).order(Sequel.desc(:id)).limit(limit)
    temp.max_block = Block.max(:height)
    temp.transaction_count = Ledger
                                 .where(:ledger__address => params[:address])
                                 .group(:ledger__txid, :ledger__type).count()
    temp.sent = (Ledger.where(:address => params[:address], :type => 'input').sum(:value))
    if temp.sent != nil
      temp.sent = temp.sent.abs.round(6)
    else
      temp.sent = 0
    end
    temp.received = Ledger.where(:address => params[:address], :type => 'output').sum(:value).round(6)
    @address_data = temp
    render stream: true
  end

  def generate_qr_code(address)
    RQRCode::QRCode.new('paycoin:' + address.to_s)
  end

  def address_confirmations(txid)
    block_id = (Transaction.find(:txid => txid)).block_id
    Block.where{id >= block_id }.count
  end

  def block_find(block_id)
    Block.find(:id => block_id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find!(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      params[:address]
    end
end
