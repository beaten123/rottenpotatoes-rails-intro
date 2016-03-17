class MoviesController < ApplicationController
  def index 
    @movies = Movie.all
  end
  
  def new
    #default: render 'new' template
end
