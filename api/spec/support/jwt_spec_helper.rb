# frozen_string_literal: true

def generate_jwt_token_for_user(user)
  token = Warden::JWTAuth::UserEncoder.new.call(user, :civil_servant, nil)
  whitelist_token(token, user)
  token.first
end

def whitelist_token(token, user)
  WhitelistedJwt.create(
    token.second
      .slice('jti', 'aud')
      .merge(exp: Time.zone.at(token.second['exp']), civil_servant: user)
  )
end
