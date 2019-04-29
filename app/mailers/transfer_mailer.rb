class TransferMailer < ApplicationMailer
  default from: 'from@example.com'

  def transfer_mail(email, name)
    @email = email
    @name = name
    mail to: @email, subject: 'リーダー変更完了'
  end
end
