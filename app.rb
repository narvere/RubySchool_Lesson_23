require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello strangerzzz'
  end
end

before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do
  erb 'Can you handle a <a href="/secure/place">secret</a>?'
end

get '/login/form' do
  erb :login_form
end

get '/about' do
  erb :about
end

get '/visit' do
  erb :visit
end

get '/contacts' do
  erb :contacts
end

post '/login/attempt' do
  session[:identity] = params['username']
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end

get '/secure/place' do
  erb 'This is a secret place that only <%=session[:identity]%> has access to!'
end

post('/visit') do
 @name = params[:name]
 @phone = params[:phone]
 @date = params[:date]
 @parik = params[:parik]
 @color = params[:color]

 f = File.open './public/users.txt', 'a'
 f.write "User: #{@name} will call #{@phone} at #{@date} by #{@parik} in #{@color}.\n"
 f.close
 erb :visit
end

post('/contacts') do
  @email = params[:email]
  @text = params[:text]

  f = File.open './public/contacts.txt', 'a'
  f.write "email: #{@email} Message: #{@text}.\n"
  f.close
  erb :contacts
end