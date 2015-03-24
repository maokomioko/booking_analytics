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
#
# Indexes
#
#  index_settings_on_company_id  (company_id) UNIQUE
#

class Setting < ActiveRecord::Base
  CRAWLING_FREQUENCIES = [
      2.hours, 3.hours, 4.hours, 5.hours, 6.hours
  ].map(&:to_i).freeze

  STARS = (1..5).to_a.freeze

  USER_RATINGS = (0..100).to_a.map{ |n| n.to_f / 10 }.freeze

  belongs_to :company

  after_save :reload_hotel_workers, if: -> { self.crawling_frequency_changed? }

  validates_inclusion_of :crawling_frequency, within: CRAWLING_FREQUENCIES
  validates :stars, array: { inclusion: { in: STARS } }
  validates :user_ratings, array: { inclusion: { in: USER_RATINGS } }
  validates :property_types, array: { inclusion: { in: Hotel::OLD_PROPERTY_TYPES.keys } }

  def self.default_attributes
    {
        crawling_frequency: CRAWLING_FREQUENCIES.max,
        stars: [ 3, 4 ],
        user_ratings: (60..70).to_a.map{ |n| n.to_f / 10 },
        property_types: Hotel::OLD_PROPERTY_TYPES.keys.first(3)
    }
  end

  private

  def reload_hotel_workers
    Hotel.where(booking_id: company.channel_managers.pluck(:booking_id)).each do |hotel|

    end
  end
end
