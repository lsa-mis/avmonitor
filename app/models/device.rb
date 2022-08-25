# == Schema Information
#
# Table name: devices
#
#  id          :bigint           not null, primary key
#  name        :string(255)      not null
#  description :string(255)
#  room_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Device < ApplicationRecord
  belongs_to :room
  has_many :device_states, dependent: :destroy
end
