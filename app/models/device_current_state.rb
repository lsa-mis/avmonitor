# == Schema Information
#
# Table name: device_current_states
#
#  id         :bigint           not null, primary key
#  key        :string(255)      not null
#  value      :string(255)
#  notes      :string(255)
#  device_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class DeviceCurrentState < ApplicationRecord
  belongs_to :device
end
