# frozen_string_literal: true

module Web::Users
  class Passwords::ResetController < BaseController
    layout "web/guest"

    skip_before_action :authenticate_user!

    def edit
      input = User::Password::Resetting::Input.new(token: params[:token])

      render("web/user/passwords/reset", locals: {user: input})
    end

    def update
      case User::Password::Resetting.call(token: params[:token], **password_params)
      in Solid::Success
        redirect_to new_web_guests_session_path, notice: "Your password has been reset successfully. Please sign in."
      in Solid::Failure(:user_not_found, _)
        redirect_to new_web_guests_password_path, alert: "Invalid or expired token."
      in Solid::Failure(input:)
        render("web/user/passwords/reset", status: :unprocessable_entity, locals: {user: input})
      end
    end

    private

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  end
end
