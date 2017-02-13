class StaticReportWorker
  include Sidekiq::Worker

  def perform
    StaticReportMailer.static_monthly_report.deliver_now
  end
end
