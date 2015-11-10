class UserMailer < ActionMailer::Base
  default from: "Kursed Apparel <info@kursedapparel.com>"

  def signup_email(user)
    @user = user
    @twitter_message = "Stoked on this new @Kursedapparel collection! I’m going to be wearing streetwear for free."

    mail(:to => user.email, :subject => "Thanks for signing up!")
  end
end
