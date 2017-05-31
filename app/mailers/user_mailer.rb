class UserMailer < ApplicationMailer

  # Sends password-reset e-mail.
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
