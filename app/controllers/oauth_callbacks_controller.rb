class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def vkontakte
    email = request.env['omniauth.auth'].info[:email]
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.present?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
    elsif @user.nil? && email.nil?
      session["oauth_params"] = { uid: request.env['omniauth.auth'].uid, provider: request.env['omniauth.auth'].provider }
      redirect_to new_user_confirmation_path
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
