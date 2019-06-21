class User < ActiveRecord::Base
    has_many :reviews
    has_many :video_games, through: :reviews

    def self.find_by_username(user)
        self.find_by(user_name: user)
    end

end