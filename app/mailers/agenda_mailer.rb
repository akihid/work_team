class AgendaMailer < ApplicationMailer
  default from: 'from@example.com'

  def agenda_mail(email ,team, agenda)
    @email = email
    @team = team
    @agenda = agenda
    mail to: @email, subject: '削除完了'
  end
end
