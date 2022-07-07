class RoomsController < ApplicationController
  before_action :set_room, only: %i[ show edit update destroy ]
  include ApplicationHelper

  # GET /rooms or /rooms.json
  def index

    if params[:no_device]
      @rooms = Room.no_device
    else
      @q = Room.active.ransack(params[:q])
      @rooms = @q.result.order(:facility_id)
    end

    @room_types = Room.all.pluck(:room_type).uniq.sort

    if params[:need_attention]
      attention_rooms = []
      @rooms.each do |room|
        devices = Device.where(room_id: room.id).where.not(name: 'Room')
        catch :attention do
          devices.each do |device|
            DeviceState.where(device_id: device.id).select(:key, :value, 'MAX(created_at)').group(:key).each do |state|
              if state_need_attention?(state)
                attention_rooms << room
                throw :attention 
              end
            end
          end
        end
      end
      @rooms = attention_rooms
    end

    unless params[:q].nil?
      render turbo_stream: turbo_stream.replace(
      :roomListing,
      partial: "rooms/listing"
    )
    end
  end

  # GET /rooms/1 or /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms or /rooms.json
  def create
    @room = Room.new(room_params)

    room_data = get_room_data_from_oracle(room_params[:facility_id])

    if room_data.nil?
      flash.now[:error] = "No data for this room in MPathways"
    else
      @room.room_type = room_data[0]
      @room.building = room_data[1]
      @room.building_nickname = room_data[2].split[1]
    
      respond_to do |format|
        if @room.save
          format.turbo_stream 
          format.html { redirect_to room_url(@room), notice: "Room was successfully created." }
          format.json { render :show, status: :created, location: @room }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @room.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /rooms/1 or /rooms/1.json
  def update
    room_data = get_room_data_from_oracle(room_params[:facility_id])

    unless room_data.nil?
      @room.room_type = room_data[0]
      @room.building = room_data[1]
      @room.building_nickname = room_data[2].split[1]
    end
    
    respond_to do |format|
      if @room.update(room_params)
        format.turbo_stream
        format.html { redirect_to room_url(@room), notice: "Room was successfully updated." }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1 or /rooms/1.json
  def destroy
    @room.destroy

    respond_to do |format|
      format.html { redirect_to rooms_url, notice: "Room was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    def get_room_data_from_oracle(facility_id)
      oracle_database = OCI8.new("#{Rails.application.credentials.oracle_db[:username]}", "#{Rails.application.credentials.oracle_db[:password]}", "#{Rails.application.credentials.oracle_db[:database]}")

      sql = "SELECT f.RMTYP_DESCR, f.BLD_DESCR, f.FACILITY_DESCR
        FROM M_SRDW1.FACILITY_TBL f
        WHERE f.facility_effdt = (SELECT MAX(f1.facility_effdt)
                                FROM m_srdw1.facility_tbl f1
                                WHERE f1.facility_id = f.facility_id
                                  AND f1.facility_effdt <= SYSDATE)
        AND f.FACILITY_ID = " + "'#{facility_id}'"

      cursor = oracle_database.parse(sql)
      cursor.exec
      return cursor.fetch
    end

    # Only allow a list of trusted parameters through.
    def room_params
      params.require(:room).permit(:websocket_ip, :websocket_port, :facility_id, :building, :room_type)
    end
end
