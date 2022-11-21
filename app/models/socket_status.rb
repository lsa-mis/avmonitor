# == Schema Information
#
# Table name: socket_statuses
#
#  id          :bigint           not null, primary key
#  socket_name :string(255)
#  status      :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class SocketStatus < ApplicationRecord
end
