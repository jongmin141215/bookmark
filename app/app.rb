require 'sinatra/base'
require './app/data_mapper_setup'

class BookmarkManager < Sinatra::Base
  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  post '/links' do
    Link.create(title: params[:title], url: params[:url])
    redirect to '/links'
  end

  get '/links/new' do
    erb :'links/new'
  end

end
