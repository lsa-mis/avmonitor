# == Schema Information
#
# Table name: rooms
#
#  id                :bigint           not null, primary key
#  websocket_ip      :string(255)      not null
#  websocket_port    :string(255)      not null
#  facility_id       :string(255)      not null
#  building          :string(255)      not null
#  room_type         :string(255)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  building_nickname :string(255)
#  tport             :integer          not null
#
class Room < ApplicationRecord
  has_many :devices, dependent: :destroy
  has_many :notes, as: :noteable

  validates :websocket_ip, :presence => true, :uniqueness => true,
  :format => { :with => Resolv::AddressRegex }
  validates :websocket_port, :presence => true
  validates :facility_id, :uniqueness => { message: "is taken" }

  HUMANIZED_ATTRIBUTES = {
    :facility_id => "Name/Facility ID",
  }

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  def display_name
    "#{self.facility_id}"
  end

end
