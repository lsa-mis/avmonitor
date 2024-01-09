class Rooms::NotesController < ApplicationController
  include Noteable

  before_action :set_noteable

  private

    def set_noteable
      @noteable = Room.find(params[:room_id])
    end
    
end
