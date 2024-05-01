# frozen_string_literal: true

module Web::Guest
  class Passwords::ResetController < BaseController
    before_action :set_user_by_token

    def edit
      render("web/guest/passwords/reset", locals: {user: @user})
    end

    def update
      if @user.update(password_params)
        redirect_to new_web_guest_session_path, notice: "Your password has been reset successfully. Please sign in."
      else
        render("web/guest/passwords/reset", status: :unprocessable_entity, locals: {user: @user})
      end
    end

    private

    def set_user_by_token
      @user = ::User.find_by_token_for(:reset_password, params[:token])

      redirect_to new_web_guest_password_path, alert: "Invalid or expired token." unless @user
    end

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  end
end