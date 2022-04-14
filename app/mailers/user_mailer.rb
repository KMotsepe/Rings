class UserMailer < ApplicationMailer
    default from: 'vacixzaro@gmail.com'
    
    def welcome_email(user)
        @user = user
        mail(to: @user.email, subject: 'Welcome to our site!')
    end
    
    def car_available(user, car)
        @user = user
        @car = car
        mail(to: @user.email, subject: 'The car you are waiting is available now!')
    end
end
