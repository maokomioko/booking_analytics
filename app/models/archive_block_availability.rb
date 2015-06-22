# == Schema Information
#
# Table name: archive_block_availabilities
#
#  id            :integer          primary key
#  max_occupancy :string
#  data          :jsonb
#  booking_id    :integer
#  fetch_stamp   :string
#

class ArchiveBlockAvailability < BlockAvailability
  self.table_name = 'archive_block_availabilities'

  private

  def self.collection_name
    :archive_block_availability
  end
end
