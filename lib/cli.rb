class CommandLineInterface

    def greet
        puts 'Welcome to GameHub! The best video game review site in the world!'
    end

    def menu
        prompt = TTY::Prompt.new
        @input = prompt.select("User select an option from the GameHub:", ["Browse Reviews", "Find Review By Game Title", "Find Reviews By User Name", "Highly Rated Video Games", "Exit"])
    end

    def menu_choice
        case @input
        when "Browse Reviews"
            all_reviews
        when "Find Review By Game Title"
            request_game_title
            find_by_title
        when "Find Reviews By User Name"
            puts "place holder"
        when "highly Rated Video Games"
            popular_games
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
            sleep 3
            menu
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

end