# == Schema Information
#
# Table name: rooms
#
#  id             :integer          not null, primary key
#  websocket_ip   :string           not null
#  websocket_port :string           not null
#  facility_id    :string           not null
#  building       :string           not null
#  room_type      :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Room < ApplicationRecord
  has_many :devices

  scope :active, -> { Room.where.associated(:devices).distinct }

  def display_name
    "#{self.facility_id}"
  end

end
