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

  after_create_commit { broadcast_update_to("attention_channel", target: 'attention_message') }
  
end
