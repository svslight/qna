class QnaOauthController < Devise::OmniauthCallbacksController

  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong, user 404'
    end
  end

  def vkontakte
    render json: request.env['omniauth.auth']
  end
end
