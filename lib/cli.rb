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
            find_by_title
            sleep 4
            menu
            menu_choice
        when "Find Reviews By User Name"
            request_user
            find_by_username
            sleep 4
            menu
            menu_choice
        when "Highly Rated Video Games"
            popular_games
            sleep 4
            menu
            menu_choice
        when "Write Review"
            review_input
            create_user
            create_review
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

    def login
        puts "Please enter you're name?"
        name = gets.chomp
        @current_user = User.find_by(user_name: name)
        menu
        menu_choice
    end

    def request_game_title
        puts ""
        puts "To find some GameHub reviews enter a Video Game title here:"
        @video_game_title = gets.chomp
    end

    def find_by_title
        find_game = VideoGame.find_by(title: @video_game_title)
        puts "-------------------"
        puts ""
        puts find_game.title.upcase
        puts ""
        
        find_game.reviews.map do |review|
            puts "Rating: #{review.rating}/5"
            puts "Review: #{review.review_description}"
            puts ""
        end
    end

    def request_user
        puts ""
        puts "To find some user reviews enter a user name here:"
        @request_user = gets.chomp
        puts ""
    end

    def find_by_username
        find_user = User.find_by(user_name: @request_user)
        puts ""
        puts find_user.user_name.upcase
        puts ""
        
        find_user.reviews.map do |review|
            puts "-------------------"
            puts "Video Game: #{review.video_game.title}"
            puts "Rating: #{review.rating}/5"
            puts "Review: #{review.review_description}"
            puts ""
            #puts review.video_game.title
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

    def print_review(review)
        puts "-------------------"
            puts ""
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

    def popular_games
        @popular_titles = []
        Review.all.map do |review|
            if review.rating > 3
              @popular_titles << review.video_game.title.upcase
            end
        end
        puts ""
        puts "-------------------"
        puts "The following games have a rating of 3/5 or higher!"
        puts "-------------------"
        puts ""
        puts @popular_titles.uniq
        puts ""
        puts "-------------------"
    end

    def review_input
        puts ""
        puts "Would you like to tell GameHub about who you are, and which game you'd like to review?"
        puts ""
        puts "-------------------"
        puts  ""
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
        puts "Thanks for the review you gamer!"
        puts ""
    end

    def update_review
        request_user
        puts "which GameHub review would you like to update, enter a Video Game title here:"
        @update_video_game_title = gets.chomp
        @update_rating = prompt.ask('update this game with a new rating out of 5:', default: ENV['0'])
        puts "-------------------"
        @update_review = prompt.ask('update this review wihh new content:', default: ENV['no review'])
        find_user = User.find_by(user_name: @request_user)
            find_user.reviews.map do |review_by_user|
                if review_by_user.video_game.title == @update_video_game_title
                    review_by_user.update(user_id: review_by_user.user.id, video_game_id: review_by_user.video_game.id, rating: @update_rating, review_description: @update_review)
                    puts "-------------------"
                    puts "Great news! Your review has been updated!"
                end
            end
    end

    def delete_review
        request_user
        puts "which GameHub review would you like to delete, enter a Video Game title here:"
        puts "-------------------"
        @update_video_game_title = gets.chomp
        find_user = User.find_by(user_name: @request_user)
            find_user.reviews.map do |review_by_user|
                if review_by_user.video_game.title == @update_video_game_title
                    review_by_user.delete
                    puts "-------------------"
                    puts "Your review has been deleted from our database"
                end
            end
    end
end