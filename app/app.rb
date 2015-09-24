require 'sinatra/base'
require 'sinatra/flash'
require './app/data_mapper_setup'

class BookmarkManager < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  set :session_secret, 'super secret'

  helpers do
    def current_user
      @current_user = User.get(session[:user_id])
    end
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  post '/links' do
    link = Link.new(title: params[:title], url: params[:url])
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

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end

  post '/users' do
    @user = User.new(email: params[:email],
                    password: params[:password],
                    password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to '/links'
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/new'
    end
  end

  get '/sessions/new' do
    erb :'sessions/new'
  end

  post '/sessions' do
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect to ('/links')
    else
      flash.now[:errors] = ['The email or password is incorrect']
      erb :'sessions/new'
    end

  end

end
