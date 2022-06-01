class User < ApplicationRecord
  class << self
    # Google OAuth2 を経て得たユーザ情報をもとにレコード作成・検索
    def find_or_create_from_auth_hash(auth_hash)
      user_params = user_params_from_auth_hash(auth_hash)

      find_or_create_by(email: user_params[:email]) do |user|
        user.update(user_params)
      end
    end

    private

    # 認証情報から取得した値を Hash 形式で紐付け
    def user_params_from_auth_hash(auth_hash)
      {
        name: auth_hash.info.name,
        email: auth_hash.info.email,
        # image: auth_hash.info.image,
      }
    end
  end
end
