# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# FeedbackController
class FeedbackController < ApplicationController
  skip_before_filter  :authorize

  # POST/feedback
  def create
    subject = params[:subject]
    body    = params[:body]
    user    = User.find(session[:user_id])
    # KBBTODO #75 use delay jobs
    UserMailer.send_feedback(user, subject, body).deliver
    render json: @@response
  end

end
