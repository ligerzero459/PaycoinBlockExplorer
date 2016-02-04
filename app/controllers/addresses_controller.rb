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
    @address = Address.find(:address => params[:address])
    @ledger = Ledger.select(:id, :txid, :address, :type)
                  .select_append{sum(:value).as(value)}
                  .select_append{max(:balance).as(balance)}
                  .where(:address => params[:address], :type => 'output')
                  .group(:txid, :type).order(Sequel.desc(:id)).limit(15)
                  .union(Ledger.select(:id, :txid, :address, :type)
                             .select_append{sum(:value).as(value)}
                             .select_append{max(:balance).as(balance)}
                             .where(:address => params[:address], :type => 'input')
                             .group(:txid, :type)
                  ).order(Sequel.desc(:id)).limit(15)

    @sent = (Ledger.where(:address => params[:address], :type => 'input').sum(:value))
    if @sent != nil
      @sent = @sent.abs.round(6)
    else
      @sent = 0
    end
    @received = Ledger.where(:address => params[:address], :type => 'output').sum(:value).round(6)
  end

  def generate_qr_code(address)
    qr = RQRCode::QRCode.new('paycoin:' + address.to_s)
    qr
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
