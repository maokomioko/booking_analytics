# == Schema Information
#
# Table name: archive_block_availabilities
#
#  max_occupancy :string
#  data          :jsonb
#  booking_id    :integer
#  fetch_stamp   :string
#  id            :integer          not null, primary key
#

class ArchiveBlockAvailability < BlockAvailability
  self.table_name = 'archive_block_availabilities'

  private

  def self.collection_name
    :archive_block_availability
  end
end
