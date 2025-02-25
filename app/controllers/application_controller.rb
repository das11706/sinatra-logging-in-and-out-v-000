require_relative '../../config/environment'
class ApplicationController < Sinatra::Base
  configure do
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  post '/login' do
    # binding.pry
    user = User.new(:username => params[:username], :password => params[:password], :balance => params[:balance])
    user = User.find_by(:username => params[:username])
    if user
      session[:user_id] = user.id
      redirect '/account'
    else
      redirect '/error'
    end
  end

  get '/account' do
    if Helpers.is_logged_in?(session)
      erb :account
    else
      redirect "/"
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/error' do
    erb :error
  end
end

