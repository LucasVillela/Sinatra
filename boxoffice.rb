require 'sinatra'
require 'sinatra/content_for'
require 'sinatra/static_assets'
require 'shotgun'
require 'nokogiri'
require 'open-uri'
require 'mysql2'
require './boxofficecode'



get '/' do
  
  @glist = grossingList

  erb :index
end

get '/test' do


  erb :test
  
end