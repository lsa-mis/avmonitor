# == Schema Information
#
# Table name: attentions
#
#  id         :bigint           not null, primary key
#  message    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Attention < ApplicationRecord

  after_create_commit do
    broadcast_update_to :attention, target: "attention_message"
  end
end
