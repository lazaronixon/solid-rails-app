# frozen_string_literal: true

module Web::Guests
  class PasswordsController < BaseController
    def new
      render("web/guest/passwords/new", locals: {user: User.new})
    end

    def create
      user = User.find_by(email: params.require(:user).require(:email))

      if user
        UserMailer.with(
          user: user,
          token: user.generate_token_for(:reset_password)
        ).reset_password.deliver_later
      end

      redirect_to new_web_guests_session_path, notice: "Check your email to reset your password."
    end
  end
end
