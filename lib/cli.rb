class CommandLineInterface
    
    attr_reader :prompt, :font, :pastel

    def initialize
        @prompt = TTY::Prompt.new
        @pastel = Pastel.new
        @font = TTY::Font.new(:doom)
    end

    def header
        puts font.write("GAME HUB")
    end

    def greet
        puts 'Welcome to GameHub! The best video game review site in the world!'
        puts ""
    end

    def login
        puts "Please enter you're name?"
        name = gets.chomp
        @current_user = User.find_or_create_by(user_name: name)
        menu
        menu_choice
    end

    def menu
        puts "-------------------"
        puts ""
        @input = prompt.select("User select an option from the GameHub:", ["All My Reviews", "Browse Reviews", "Find Reviews By Game Title", "Find Reviews By User Name", "Highly Rated Video Games", "Write Review", "Update Existing Review", "Delete Review", "Exit"])
    end

    def menu_choice
        case @input
        when "All My Reviews"
            all_my_reviews
            sleep 4
            menu
            menu_choice
        when "Browse Reviews"
            all_reviews
            sleep 4
            menu
            menu_choice
        when "Find Reviews By Game Title"
            request_game_title
            sleep 4
            menu
            menu_choice
        when "Find Reviews By User Name"
            request_user
            sleep 4
            menu
            menu_choice
        when "Highly Rated Video Games"
            highly_rated_video_games
            sleep 4
            menu
            menu_choice
        when "Write Review"
            review_input
            new_review
            sleep 4
            menu
            menu_choice
        when "Update Existing Review"
            update_review
            sleep 4
            menu
            menu_choice
        when "Delete Review"
            delete_review
            sleep 4
            menu
            menu_choice
        else "Exit"
            exit
        end
    end

    def request_game_title
        puts ""
        puts "To find some GameHub reviews enter a Video Game title here:"
        @video_game_title = gets.chomp
        find_game = VideoGame.find_by_title(@video_game_title)
        find_game.reviews.map do |review|
            print_review(review)
        end
    end

    def request_user
        puts ""
        puts "To find some user reviews enter a user name here:"
        @request_user = gets.chomp
        find_user = User.find_by_username(@request_user)
        find_user.reviews.map do |review|
            print_review(review)
        end
    end

    def all_reviews
        Review.all.map do |review|
            print_review(review)
        end
    end

    def print_review(review)
        puts "-------------------"
            puts "#{review.video_game.title.upcase}"
            puts ""
            puts "User: #{review.user.user_name}"
            puts "Rating: #{review.rating}/5"
            puts "Review: #{review.review_description}"
    end

    def all_my_reviews
        @current_user.reviews.each do |review| 
            print_review(review)
        end
    end

    def highly_rated_video_games
        highly_rated = Review.popular_games
        highly_rated.map do |review|
            print_review(review)
        end
    end

    def review_input
        puts ""
        puts "-------------------"
        @string_title = prompt.select("Which title from GameHub would you like to review?:", ["Tomb Raider", "Fifa 19", "Goldeneye", "Crash Bandicoot", "GTA Vice City", "Mario Kart", "Splinter Cell", "Tony Hawks Pro Skater 3", "Gran Turismo 3", "Halo"])      
        @new_title = VideoGame.find_by(title: @string_title)
        puts "-------------------"
        @new_rating = prompt.ask('What would you rate this game out of 5?', default: ENV['0'])
        puts "-------------------"
        @new_review = prompt.ask('Tell us about this game:', default: ENV['no review'])
    end

    def new_review
        Review.create_review(@current_user.id, @new_title.id, @new_rating, @new_review)
        puts ""
        puts "Thanks for the review you gamer!"
        puts ""
    end

    def update_review
        puts "Enter review by title to update:"
        @game_title = gets.chomp
        @nnew_rating = prompt.ask('What would you rate this game out of 5?', default: ENV['0'])
        @nnew_review = prompt.ask('Tell us about this game:', default: ENV['no review'])
        @current_user.reviews.map do |review|
            if review.video_game.title == @game_title
                review.update(user_id: @current_user.id, video_game_id: review.video_game.id, rating: @nnew_rating, review_description: @nnew_review)
            end
        end
        puts "-------------------"
        puts "Great news! Your review has been updated!"
    end

    def delete_review
        puts "which GameHub review would you like to delete, enter a Video Game title here:"
        puts "-------------------"
        @update_video_game_title = gets.chomp
            @current_user.reviews.map do |review_by_user|
                if review_by_user.video_game.title == @update_video_game_title
                    review_by_user.delete
                    puts "-------------------"
                    puts "Your review has been deleted from our database"
                end
            end
    end

    def delete_all_reviews
        
    end
end