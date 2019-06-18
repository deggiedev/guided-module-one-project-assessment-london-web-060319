class CreateReviewTable < ActiveRecord::Migration[4.2]
    def change
        create_table :reviews do |t|
            t.integer :user_id
            t.integer :video_game_id
            t.integer :rating
            t.string :review_description
        end
    end
end