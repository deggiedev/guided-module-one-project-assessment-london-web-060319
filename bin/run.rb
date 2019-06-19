require_relative '../config/environment'
cli = CommandLineInterface.new
#prompt = TTY::Prompt.new
puts ""
cli.greet
puts "********************"
puts ""
#prompt.select("Choose an option below:", %w(Browse_reviews  Reviews_by_game_title Reviews_by_rating Most_popular_game))

puts "To find some GameHub reviews enter a Video Game title here:"
@video_game_title = gets.chomp
puts ""

#Find Review by Title
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
    end
end

find_by_title

#Browse through all reviews
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

all_reviews

#find popular games with a rating of 3 or over
def popular_games
    Review.all.map do |review|
        if review.rating > 3 
            puts "-------------------"
            puts ""
            puts review.video_game.title.upcase
        end
    end
end

popular_games

#puts "Enter a rating between 1 and 5 here:"
#@review_rating = gets.chomp
#puts ""

#Find Review by Rating
#def find_by_rating
    #Review.all.map do |review|
        #if review.rating == @review_rating
            #puts review.video_game.title.upcase
            #puts review.rating
            #puts review.review_description
        #end
    #end
#end

#find_by_rating