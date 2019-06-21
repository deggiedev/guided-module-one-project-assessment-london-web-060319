class VideoGame < ActiveRecord::Base
    has_many :reviews
    has_many :users, through: :reviews

    def self.find_by_title(title)
        self.find_by(title: title)
    end
end