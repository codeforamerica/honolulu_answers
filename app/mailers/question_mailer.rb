class QuestionMailer < ActionMailer::Base
  default from: ENV['QUESTION_EMAIL_FROM']

  def submitted_question(question)
    @question = Question.find(question.id)
    mail(:to => ENV['CONTACT_EMAIL'], :subject => "[#{ENV['SITE_NAME']}] New question by #{question.name}")
  end
end
