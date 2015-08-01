# == Schema Information
#
# Table name: archive_block_availabilities
#
#  id            :integer          primary key
#  data          :jsonb
#  booking_id    :integer
#  max_occupancy :text             is an Array
#  fetch_stamp   :integer
#

class ArchiveBlockAvailability < BlockAvailability
  self.table_name = 'archive_block_availabilities'

  private

  def self.collection_name
    :archive_block_availability
  end
end
