class MoviesController < ApplicationController
  
   def index 
     
      sort = params[:sort] 
    case sort 
    when 'title' 
      @movies = Movie.order('title').all 
    when 'date' 
      @movies = Movie.order('release_date') 
    when nil 
      @movies = Movie.all 
    end 

     @all_ratings = ['G', 'PG', 'PG-13', 'R'] 
 
 
     session[:ratings] = params[:ratings] if params[:ratings] 
     session[:sort]    = params[:sort]    if params[:sort] 
 
 
     if session[:ratings] || session[:sort] 
       case session[:sort] 
       when 'title' 
         @title_hilite = 'hilite' 
       when 'release_date' 
         @release_hilite = 'hilite' 
       end 
 
 
       session[:ratings] ||= @all_ratings 
       @ratings = session[:ratings] 
       @ratings = @ratings.keys if @ratings.respond_to?(:keys) 
       @movies = Movie.find(:all, 
                            order: session[:sort], 
                            conditions: ["rating IN (?)", @ratings]) 
     else 
       @movies = Movie.all 
     end 
 
 
     if session[:ratings] != params[:ratings] || session[:sort] != params[:sort] 
       redirect_to movies_path(ratings: session[:ratings], sort: session[:sort]) 
     end 
   end 


  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
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

end
  
