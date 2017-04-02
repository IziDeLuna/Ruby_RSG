require 'sinatra'

=begin
require 'sinatra/reloader' if development?
=end

require './rsg.rb'


post '/:grammar' do

  @grammar = params[:grammars]
  filename = "grammars/#{@grammar}"
  if(/([\w\-.])+/.match(@grammar))
    erb :error
  end

  if(!FileTest.exists? filename)
    erb :error
  else
    hs = rsg(filename)
    @sentence = hs
    erb :rsg
  end
end


get '/' do
  erb :layout
end

error do
  erb :not_found
end

