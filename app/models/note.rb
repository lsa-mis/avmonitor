# == Schema Information
#
# Table name: notes
#
#  id            :integer          not null, primary key
#  user_id       :integer          not null
#  noteable_type :string           not null
#  noteable_id   :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Note < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :user
  belongs_to :noteable, polymorphic: true

  has_rich_text :body

  validates :body, presence: true

  after_create_commit do
    broadcast_prepend_to [noteable, :notes], target: "#{dom_id(noteable)}_notes"
  end
  after_update_commit do
    broadcast_prepend_to [noteable, :notes], target: "#{ dom_id noteable }_notes"
  end
  after_destroy_commit do
    broadcast_remove_to self
  end
end
