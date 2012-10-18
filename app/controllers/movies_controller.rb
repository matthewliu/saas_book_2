class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.available_ratings
    @checked_ratings = @all_ratings

    if params[:ratings] 
      @checked_ratings = params[:ratings].keys
      session[:saved_checked_ratings] = @checked_ratings
    elsif session[:saved_checked_ratings]
      @checked_ratings = session[:saved_checked_ratings]
    else
      @checked_ratings = @all_ratings
    end
    
    if params[:sort]
      @selected_sort = params[:sort]
      session[:saved_sort] = @selected_sort
    else
      @selected_sort = session[:saved_sort]
    end
    
    @movies = Movie.find_all_by_rating(@checked_ratings, :order => @selected_sort)
    
    if @selected_sort == 'title'
      @title_style = 'hilite'
    elsif @selected_sort == 'release_date'
      @release_date_style = 'hilite'
    end    
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
