class UserMailer < ActionMailer::Base
    default from: "Kursed <hello@kursed.com>"

    def signup_email(user)
        @user = user
        @twitter_message = ""

        mail(:to => user.email, :subject => "Thanks for signing up!")
    end
end
