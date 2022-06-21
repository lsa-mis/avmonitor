# == Schema Information
#
# Table name: device_states
#
#  id         :integer          not null, primary key
#  key        :string           not null
#  value      :string
#  notes      :string
#  device_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class DeviceState < ApplicationRecord
  belongs_to :device
end
