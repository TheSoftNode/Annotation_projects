class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]
  before_action :check_authorization, only: [:show, :edit, :update, :destroy, :new, :create]

  def index
    @devices = Device.all
  end

  def show
  end

  def new
    @device = Device.new
  end

  def create
    @device = Device.new(device_params)
    if @device.save
      redirect_to "/cs/devices/#{@device.id}", status: :found
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @device.update(device_params)
      redirect_to "/cs/devices/#{@device.id}", status: :found
    else
      render :edit
    end
  end

  def destroy
    @device.destroy
    redirect_to '/cs/devices', status: :found
  end

  private

  def set_device
    @device = Device.find_by(id: params[:id])
  end

  def check_authorization
    @current_user = User.find_by(id: session[:user_id]) if session[:user_id]

    # For new/create, check entity_id param
    if ['new', 'create'].include?(action_name)
      entity_id = params[:entity_id] || params.dig(:device, :entity_id)
      unless @current_user&.entity_ids&.include?(entity_id.to_i)
        render plain: 'Not Found', status: :not_found
        return
      end
    else
      # For show/edit/update/destroy, check device's entity
      if @device.nil? || !@current_user&.entity_ids&.include?(@device.entity_id)
        render plain: 'Not Found', status: :not_found
        return
      end
    end
  end

  def device_params
    params.require(:device).permit(:name, :entity_id, :customer_id)
  end
end
