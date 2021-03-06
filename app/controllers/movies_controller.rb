class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
        @allRatings = Movie.all_ratings

        if(params[:sort] != nil and params[:sort] != session[:sort])
          session[:sort] = params[:sort]
        end
        if(params[:ratings] != nil and params[:ratings] != session[:ratings])
        session[:ratings] = params[:ratings]
        end

        session_params = { :sort => session[:sort], :ratings => session[:ratings] }
        param_params = { :sort => params[:sort], :ratings => params[:ratings] }

        if(session_params != param_params)
          flash.keep
          redirect_to(session_params)
        end


        if(session[:ratings] != nil)
          @selected_ratings =session[:ratings].keys
        else
          @selected_ratings =Movie.all_ratings
        end

        if(session[:sort]=='title')
          if (session[:ratings] )
            @movies = Movie.where("rating in (?)", @selected_ratings).order('title')
          else
            @movies = Movie.all.order('title')
          end
        elsif(session[:sort]=='release_date')
          if (session[:ratings])
            @movies = Movie.where("rating in (?)", @selected_ratings).order('release_date')
          else
            @movies = Movie.all.order('release_date')
          end
        else
          if (session[:ratings] )
            @movies = Movie.where("rating in (?)", @selected_ratings)
          else
          @movies = Movie.all
          end
        end
        @title_header = params[:sort]=='title' ?'high-light':nil
        @release_date_header = params[:sort]=='release_date' ?'high-light':nil
  end
  def new
    # default: render 'new' template
  end
  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end
  def edit
    @movie = Movie.find params[:id]
  end
  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  #private
  #def get_array(priority_array, stored_array)
  #  if !priority_array.nil? and stored_array != priority_array
  #    stored_array = priority_array
  #  end
  #  return stored_array
  #end

end
