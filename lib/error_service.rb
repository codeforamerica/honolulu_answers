# Public: Wrapper for the exception handling service, Rollbar
class ErrorService
  def self.report(exception)
    Rails.logger.error(exception.inspect)
    ReportExceptionJob.schedule(exception) if send_to_external?
  end

  private

  def self.send_to_external?
    Rails.env.production? || Rails.env.staging?
  end
end
