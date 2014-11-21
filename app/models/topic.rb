# Renjie Long
# Bryant
class Topic < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :messages
  belongs_to :channel

  validates_uniqueness_of :name, :scope => :channel_id
end
