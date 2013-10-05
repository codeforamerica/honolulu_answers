# Public: Wrapper for the exception handling service, Rollbar
class ErrorService
  def self.report(exception)
    Rails.logger.error(exception.inspect)
    Rails.logger.error(exception.backtrace)
    ReportExceptionJob.schedule(exception) if send_to_external?
    raise exception if re_raise?
  end

  private

  def self.send_to_external?
    Rails.env.production? || Rails.env.staging?
  end

  def self.re_raise?
    Rails.env.test?
  end
end
