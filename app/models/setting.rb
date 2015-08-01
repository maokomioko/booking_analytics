# == Schema Information
#
# Table name: settings
#
#  id                 :integer          not null, primary key
#  crawling_frequency :integer
#  stars              :text             default([]), is an Array
#  user_ratings       :text             default([]), is an Array
#  property_types     :text             default([]), is an Array
#  company_id         :integer
#  created_at         :datetime
#  updated_at         :datetime
#  districts          :text             default([]), is an Array
#  strategy           :string
#  current_job        :string
#  sidekiq_lock       :boolean          default(FALSE)
#
# Indexes
#
#  index_settings_on_company_id  (company_id) UNIQUE
#

class Setting < ActiveRecord::Base
  CRAWLING_FREQUENCIES = [
    2.hours, 3.hours, 4.hours, 5.hours, 6.hours
  ].map(&:to_i).freeze

  STARS = (1..5).to_a.map(&:to_s).freeze

  USER_RATINGS = (0..100).to_a.map { |n| (n.to_f / 10).to_s }.freeze

  attr_accessor :user_ratings_range

  is_impressionable

  belongs_to :company

  has_many :room_settings do
    def room_hash
      each_with_object({}) do |rs, hash|
        hash[rs.room_id] = rs
      end
    end
  end

  after_create :create_room_settings

  after_update :restart_algorithm
  after_save :recreate_related_hotels

  validates_inclusion_of :crawling_frequency, within: CRAWLING_FREQUENCIES
  validates :stars, array: { inclusion: { in: STARS } }
  validates :user_ratings, array: { inclusion: { in: USER_RATINGS } }
  validates :property_types, array: { inclusion: { in: Hotel::OLD_PROPERTY_TYPES.keys } }

  def user_ratings_range
    @user_ratings_range ||
    begin
      OpenStruct.new(
        from: user_ratings.map(&:to_f).min * 10,
        to: user_ratings.map(&:to_f).max * 10
      )
    rescue
      OpenStruct.new(
        from: 1,
        to: 100
      )
    end
  end

  def user_ratings_range= (hash)
    @user_ratings_range = OpenStruct.new hash
    range = user_ratings_range.from..user_ratings_range.to
    self[:user_ratings] = range.to_a.map{ |x| (x.to_f / 10).to_s }
  end

  def lock!
    update_column(:sidekiq_lock, true)
  end

  def unlock!
    update_column(:sidekiq_lock, false)
  end

  def hotel
    company.channel_manager.hotel rescue nil
  end

  private

  def restart_algorithm
    PriceMaker::PriceWorker.perform_async(id)
  end

  def recreate_related_hotels
    if hotel.present?
      RelatedHotelsCleanerWorker.new.perform(company_id)
      hotel.amenities_calc(company_id, true)
    end
    true
  end

  def create_room_settings
    return true unless hotel.present?
    hotel.rooms.pluck(:id).each do |room_id|
      RoomSetting.find_or_create_by(room_id: room_id, setting: self) do |obj|
        obj.position = 1
      end
    end
  end
end
