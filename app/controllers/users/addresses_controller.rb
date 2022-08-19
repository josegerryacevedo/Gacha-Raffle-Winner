class Users::AddressesController  < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: [:edit, :update, :destroy]

  def index
    @addresses = current_user.addresses.includes(:region, :province, :city, :barangay)
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    @address.user = current_user
    if @address.save
      redirect_to users_addresses_path, notice: 'Successfully Submitted'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @address.update(address_params)
      redirect_to users_addresses_path, notice: 'Successfully Updated'
    else
      render :edit
    end
  end

  def destroy
    if @address.destroy
      redirect_to users_addresses_path, notice: 'Successfully Deleted'
    else
      redirect_to users_addresses_path, alert: 'Default Address Cant Be Destroy!'
    end
  end

  private

  def address_params
    params.require(:address).permit( :genre, :is_default, :name, :street_address, :phone_number, :region_id, :province_id, :city_id, :barangay_id, :remark)
  end

  def set_address
    @address = Address.find(params[:id])
  end
end