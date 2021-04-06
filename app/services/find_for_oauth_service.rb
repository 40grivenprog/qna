class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    email = auth.info[:email]
    user = User.where(email: email).first
    if user
      create_authorization(user, auth)
    else
      user = email ? new_user_with_email(email) : nil
    end
    user
  end

  private

  def new_user_with_email(email)
    password = Devise.friendly_token[0, 20]
    user = User.create!(email: email, password: password, password_confirmation: password)
    create_authorization(user, auth)
    user
  end

  def create_authorization(user, auth)
    user.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
