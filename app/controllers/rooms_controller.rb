class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: %i[ show edit update destroy ]
  include ApplicationHelper

  # GET /rooms or /rooms.json
  def index
    min = params[:min_lamp_hour].to_i
    max = params[:max_lamp_hour].to_i

    if params[:no_device]
      @rooms = Room.no_device
      authorize @rooms
    else
      @q = Room.active.ransack(params[:q])
      @rooms = @q.result
      if (min != 0 && min > MIN_LAMP_HOURS || max != 0 && max < MAX_LAMP_HOURS)
        device_ids = []        
        DeviceCurrentState.where(key: "Lamp Hours").each do |state|
          if (state.value.to_i >= min && state.value.to_i <= max)
            device_ids << state.device_id
          end
        end
        room_ids = Device.where(id: device_ids, room_id: @rooms.pluck(:id)).pluck(:room_id)
        @rooms = Room.where(id: room_ids)
      end
      authorize @rooms
      if params[:need_attention]
        rooms = @rooms
        @rooms = rooms_need_attention(rooms)
        authorize :attention
      end
    end
    @rooms = @rooms.order(:facility_id)
    @room_types = Room.all.pluck(:room_type).uniq.sort
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
    authorize @room
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms or /rooms.json
  def create
    @room = Room.new(room_params)
    authorize @room
    room_data = get_room_data_from_oracle(room_params[:facility_id].upcase)
    if room_data.nil?
      flash.now[:alert] = "No data for this room in MPathways"
      render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
    else
      @room.room_type = room_data[0]
      @room.building = room_data[1]
      @room.building_nickname = room_data[2].split[1]
      @room.facility_id = room_params[:facility_id].upcase
      # Check for rooms presence in DB maybe ||=
      @room.tport = Room.maximum(:tport) + 1
    
      respond_to do |format|
        if @room.save
          start_room_socket(@room)
          format.html { redirect_to room_url(@room), notice: "Room was successfully created." }
          format.json { render :show, status: :created, location: @room }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @room.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def start_room_socket(room)
    socket = "wss://" + room.websocket_ip + ":" + room.websocket_port
    name = room.facility_id
    tport = room.tport
    wss_instance = ConnectSocket.new(name, socket, tport)
    t = Thread.new { wss_instance.connect }
    t.join
  end

  # PATCH/PUT /rooms/1 or /rooms/1.json
  def update
    room_data = get_room_data_from_oracle(room_params[:facility_id].upcase)

    if room_data.nil?
      flash.now[:alert] =  "No data for this room in MPathways"
      render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
    else
      
      @room.room_type = room_data[0]
      @room.building = room_data[1]
      @room.building_nickname = room_data[2].split[1]
      @room.facility_id = room_params[:facility_id].upcase
    
      respond_to do |format|
        if @room.update(room_params)
          format.html { redirect_to room_url(@room), notice: "Room was successfully updated." }
          format.json { render :show, status: :ok, location: @room }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @room.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
      authorize @room
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
