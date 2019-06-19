class CommandLineInterface

    def greet
        puts 'Welcome to GameHub! The best video game review site in the world!'
    end

    def menu
        prompt = TTY::Prompt.new
        @input = prompt.select("User select an option from the GameHub:", ["Browse Reviews", "Find Review By Game Title", "Find Reviews By User Name", "Highly Rated Video Games", "Write Review", "Exit"])
    end

    def menu_choice
        case @input
        when "Browse Reviews"
            all_reviews
        when "Find Review By Game Title"
            request_game_title
            find_by_title
        when "Find Reviews By User Name"
            request_user
            find_by_username
        when "Highly Rated Video Games"
            popular_games
        when "Write Review"
            review_input
            create_user
            create_review
        else "Exit"
            exit
        end
    end

    def request_game_title
        puts "********************"
        puts ""
        puts "To find some GameHub reviews enter a Video Game title here:"
        @video_game_title = gets.chomp
        puts ""
    end

    def find_by_title
        find_game = VideoGame.find_by(title: @video_game_title)
        puts "********************"
        puts ""
        puts find_game.title.upcase
        puts ""
        
        find_game.reviews.map do |review|
            puts "-------------------"
            puts "Rating: #{review.rating}/5"
            puts "Review: #{review.review_description}"
            puts ""
        end
    end

    def request_user
        puts "********************"
        puts ""
        puts "To find some user reviews enter a user name here:"
        @request_user = gets.chomp
        puts ""
    end

    def find_by_username
        find_user = User.find_by(user_name: @request_user)
        puts "********************"
        puts ""
        puts find_user.user_name.upcase
        puts ""
        
        find_user.reviews.map do |review|
            puts "-------------------"
            puts "Video Game: #{review.video_game.title}"
            puts "Rating: #{review.rating}/5"
            puts "Review: #{review.review_description}"
            puts ""
            puts review.video_game.title
        end
    end

    def all_reviews
        all_reviews = Review.all
        all_reviews.map do |review|
            puts "-------------------"
            puts ""
            puts "#{review.video_game.title.upcase}"
            puts ""
            puts "User: #{review.user.user_name}"
            puts "Rating: #{review.rating}/5"
            puts "Review: #{review.review_description}"
        end
    end

    def popular_games
        Review.all.map do |review|
            if review.rating > 3 
                puts "-------------------"
                puts ""
                puts review.video_game.title.upcase
            end
        end
    end

    def review_input
        puts "********************"
        puts ""
        puts "Would you like to tell GameHub about who you are, and which game you'd like to review?"
        puts ""
        puts "********************"
        puts  ""
        prompt = TTY::Prompt.new
        @new_username = prompt.ask('What is your name?', default: ENV['USER'])
        puts "-------------------"
        @string_title = prompt.select("Which title from GameHub would you like to review?:", ["Tomb Raider", "Fifa 19", "Goldeneye", "Crash Bandicoot", "GTA Vice City", "Mario Kart", "Splinter Cell", "Tony Hawks Pro Skater 3", "Gran Turismo 3", "Halo"])
        
        @new_title = VideoGame.find_by(title: @string_title)
        puts "-------------------"
        @new_rating = prompt.ask('What would you rate this game out of 5?', default: ENV['0'])
        puts "-------------------"
        @new_review = prompt.ask('Tell us about this game:', default: ENV['no review'])
    end

    def create_user
        @createuser = User.create(user_name: @new_username)
    end

    def create_review
        review = Review.create(user_id: @createuser.id, video_game_id: @new_title.id, rating: @new_rating, review_description: @new_review)
        puts ""
        puts "Thanks for the review you nerd!"
        puts ""
    end
end