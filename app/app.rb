require 'sinatra/base'
require './app/data_mapper_setup'

class BookmarkManager < Sinatra::Base
  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  post '/links' do
    link = Link.create(title: params[:title], url: params[:url])
    strings = params[:tag].split(/\s+/)
    tags = strings.map { |tag| Tag.create(name: tag) }
    tags.each { |tag| link.tags << tag }
    link.save
    redirect to '/links'
  end

  get '/links/new' do
    erb :'links/new'
  end

  get '/tags/:tag' do
    tag = Tag.first(name: params[:tag])
    @links = tag ? tag.links : []
    erb :'links/index'
  end
end
