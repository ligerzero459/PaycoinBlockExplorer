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
    temp = OpenStruct.new
    temp.address = Address.find(:address => params[:address])
    @ledger = Ledger.join(:transactions, :txid=>:txid)
                  .join(:blocks, :id=>:transactions__block_id)
                  .select(:ledger__id, :blocks__blockHash, :blocks__height, :ledger__txid, :ledger__address, :ledger__type)
                  .select_append{sum(:ledger__value).as(value)}
                  .select_append{max(:ledger__balance).as(balance)}
                  .where(:ledger__address => params[:address], :ledger__type => 'output')
                  .group(:ledger__txid, :ledger__type).order(Sequel.desc(:id)).limit(15)
                  .union(Ledger.join(:transactions, :txid=>:txid)
                             .join(:blocks, :id=>:transactions__block_id)
                             .select(:ledger__id, :blocks__blockHash, :blocks__height, :ledger__txid, :ledger__address, :ledger__type)
                             .select_append{sum(:ledger__value).as(value)}
                             .select_append{max(:ledger__balance).as(balance)}
                             .where(:ledger__address => params[:address], :ledger__type => 'input')
                             .group(:ledger__txid, :ledger__type)
                  ).order(Sequel.desc(:id)).limit(15)
    temp.max_block = Block.max(:height)
    temp.sent = (Ledger.where(:address => params[:address], :type => 'input').sum(:value))
    if temp.sent != nil
      temp.sent = temp.sent.abs.round(6)
    else
      temp.sent = 0
    end
    temp.received = Ledger.where(:address => params[:address], :type => 'output').sum(:value).round(6)
    @address_data = temp
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
