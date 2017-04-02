require 'sinatra'
require './rsg.rb'
require './rsg.erb'

get '/' do
  if params['grammar']
    @grammar = params['grammar']
    @grammar = @grammar.gsub(/[^A-Za-z\-]/, '')
    filename = "grammar/#{@grammar}.g"
    if !FileTest.exists? "grammars/#{@grammar}.g"
      erb :not_found
    else
      erb :rsg
    end
  else
    erb :home
  end
end