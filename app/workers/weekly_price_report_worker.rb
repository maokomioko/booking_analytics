class WeeklyPriceReportWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: false, unique: true

  recurrence { daily.hour_of_day(8) } # UTC time

  def perform
    Company.includes(:users).find_each do |company|
      receiver_ids = company.users
                       .select { |u| u.role == 'manager' || u.role == 'admin' }
                       .map(&:id)

      CompanyMailer.delay.weekly_report(company.id, receiver_ids)
    end
  end
end