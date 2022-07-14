# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  has_many :meeting_schedule_candidates

  accepts_nested_attributes_for :meeting_schedule_candidates

  class << self
    # Google OAuth 2 を経て得たユーザ情報をもとにレコード作成・検索
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
