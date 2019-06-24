class CommandLineInterface
    def music
        pid = fork{ exec 'afplay', 'lib/PlayStation (PS one) Load Up Screen.mp3' }
        return pid
        #pid = fork{ exec 'killall', 'afplay' }
    end

    attr_reader :prompt, :font, :pastel

    def initialize
        @prompt = TTY::Prompt.new
        @pastel = Pastel.new
        @font = TTY::Font.new(:doom)
    end

    def header
        puts pastel.blue(font.write("GAME HUB"))
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
        @current_user.reload()
        case @input
        when "All My Reviews"
            all_my_reviews
            sleep 2
            menu
            menu_choice
        when "Browse Reviews"
            all_reviews
            sleep 2
            menu
            menu_choice
        when "Find Reviews By Game Title"
            request_game_title
            sleep 2
            menu
            menu_choice
        when "Find Reviews By User Name"
            request_user
            sleep 2
            menu
            menu_choice
        when "Highly Rated Video Games"
            highly_rated_video_games
            sleep 2
            menu
            menu_choice
        when "Write Review"
            review_input
            new_review
            sleep 2
            menu
            menu_choice
        when "Update Existing Review"
            review_input
            update_review
            sleep 2
            menu
            menu_choice
        when "Delete Review"
            delete_review
            sleep 2
            menu
            menu_choice
        else "Exit"
            exit
        end
    end

    def request_game_title
        puts ""
        @video_game_title = prompt.select("Which title from GameHub would you like to review?:", ["Tomb Raider", "Fifa 19", "Goldeneye", "Crash Bandicoot", "GTA Vice City", "Mario Kart", "Splinter Cell", "Tony Hawks Pro Skater 3", "Gran Turismo 3", "Halo"])
        #@video_game_title = gets.chomp
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
        puts ""
        puts "-------------------"
        @highly_rated = []
        highly_rated = Review.popular_games
        highly_rated.map do |review|
            @highly_rated << review.video_game.title
        end
        puts "The following games have a rating of 3/5 or higher"
        puts "-------------------"
        puts @highly_rated.uniq

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
        @review_to_update = Review.find_by(video_game: @new_title, user: @current_user )
        @review_to_update.update(user_id: @current_user.id, video_game_id: @new_title.id, rating: @new_rating, review_description: @new_review)
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
end