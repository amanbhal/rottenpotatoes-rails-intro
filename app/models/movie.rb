class Movie < ActiveRecord::Base
  def Movie.all_ratings
    all_movie_ratings = []
    Movie.all.each do |movie|
      if (!all_movie_ratings.include?(movie.rating))
        all_movie_ratings.push(movie.rating)
      end
    end
    return all_movie_ratings
  end
end
