# == Schema Information
#
# Table name: rooms
#
#  id                :integer          not null, primary key
#  websocket_ip      :string           not null
#  websocket_port    :string           not null
#  facility_id       :string           not null
#  building          :string           not null
#  room_type         :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  building_nickname :string
#
class Room < ApplicationRecord
  has_many :devices
  has_many :notes, as: :noteable

  scope :active, -> { Room.where.associated(:devices).distinct }
  scope :no_device, -> { Room.where.missing(:devices) }

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
