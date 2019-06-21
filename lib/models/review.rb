class Review < ActiveRecord::Base
    belongs_to :user
    belongs_to :video_game

    def self.popular_games
        self.where("rating > 3")
    end

    def self.create_review(user_id, video_game_id, rating, description)
        self.create(user_id: user_id, video_game_id: video_game_id, rating: rating, review_description: description)
    end

end