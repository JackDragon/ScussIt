# == Schema Information
#
# Table name: messages
#
#  id            :integer          not null, primary key
#  body          :string(255)
#  creation_time :datetime
#  created_at    :datetime
#  updated_at    :datetime
#  user_id       :integer
#  channel_id    :integer
#

require 'rails_helper'

RSpec.describe Message, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
