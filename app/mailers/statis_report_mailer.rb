class StaticReportMailer < ApplicationMailer
  def static_monthly_report
    email_admin = User.admin_email
    current_date = Time.now
    start_date = current_date.beginning_of_month
    end_date = current_date.end_of_month
    @orders = Order.monthly_order start_date, end_date
    mail to: email_admin.map(&:email).uniq, subject: t("monthly_report_subject")
  end
end
