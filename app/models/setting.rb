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
#  hotel_id           :integer
#  strategy           :string
#
# Indexes
#
#  index_settings_on_company_id  (company_id) UNIQUE
#  index_settings_on_hotel_id    (hotel_id)
#

class Setting < ActiveRecord::Base
  CRAWLING_FREQUENCIES = [
    2.hours, 3.hours, 4.hours, 5.hours, 6.hours
  ].map(&:to_i).freeze

  STARS = (1..5).to_a.map(&:to_s).freeze

  USER_RATINGS = (0..100).to_a.map { |n| (n.to_f / 10).to_s }.freeze

  is_impressionable

  belongs_to :company
  belongs_to :hotel

  after_save :reload_hotel_workers, if: -> { self.crawling_frequency_changed? }
  after_save :clean_related_hotels

  validates_inclusion_of :crawling_frequency, within: CRAWLING_FREQUENCIES
  validates :stars, array: { inclusion: { in: STARS } }
  validates :user_ratings, array: { inclusion: { in: USER_RATINGS } }
  validates :property_types, array: { inclusion: { in: Hotel::OLD_PROPERTY_TYPES.keys } }

  private

  def reload_hotel_workers
    PriceMaker::ReloadWorker.perform_async(id)
  end

  def clean_related_hotels
    RelatedHotelsCleanerWorker.perform_async(id)
  end
end
