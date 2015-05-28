class ArchiveBlockAvailability < BlockAvailability
  self.table_name = 'archive_block_availabilities'

  private

  def self.collection_name
    :archive_block_availability
  end
end
