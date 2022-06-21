# == Schema Information
#
# Table name: devices
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :string
#  room_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Device < ApplicationRecord
  belongs_to :room
  has_many :device_states
end
