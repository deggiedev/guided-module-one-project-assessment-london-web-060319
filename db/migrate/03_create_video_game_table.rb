class CreateVideoGameTable < ActiveRecord::Migration[4.2]
    def change
        create_table :video_games do |t|
            t.string :title
            t.string :creator
        end
    end
end