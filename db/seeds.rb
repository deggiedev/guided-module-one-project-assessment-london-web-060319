10.times do
    User.create(user_name: Faker::Name.name)
end

game1 = VideoGame.create(title: "Tomb Raider", creator: "Edios")
game2 = VideoGame.create(title: "Fifa 19", creator: "EA Sports")
game3 = VideoGame.create(title: "Goldeneye", creator: "Rare")
game4 = VideoGame.create(title: "Crash Bandicoot", creator: "Sony Entertainment")
game5 = VideoGame.create(title: "GTA Vice City", creator: "Rockstar Games")
game6 = VideoGame.create(title: "Mario Kart", creator: "Nintendo")
game7 = VideoGame.create(title: "Splinter Cell", creator: "Ubisoft")
game8 = VideoGame.create(title: "Tony Hawks Pro Skater 3", creator: "Activision")
game9 = VideoGame.create(title: "Gran Turismo 3", creator: "Polyphony Digital")
game10 = VideoGame.create(title: "Halo", creator: "Bungie")

10.times do
    Review.create(user_id: User.all.sample.id, video_game_id: VideoGame.all.sample.id, rating: Faker::Number.between(1, 5) , review_description: Faker::Movies::StarWars.quote)
end
