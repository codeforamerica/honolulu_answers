class ReportExceptionJob < Struct.new(:exception)
  def self.schedule(exception)
    Delayed::Job.enqueue ReportExceptionJob.new(exception)
  end

  def perform
    Rollbar.report_exception exception
  end
end
