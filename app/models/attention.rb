# == Schema Information
#
# Table name: attentions
#
#  id         :integer          not null, primary key
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Attention < ApplicationRecord

  after_create_commit { broadcast_update_to("attention_channel", target: 'attention_message') }
  
end
