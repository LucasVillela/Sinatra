require 'sinatra'
require "sinatra/content_for"
require 'shotgun'
require 'nokogiri'
require 'open-uri'
require './boxofficecode'



get '/' do
  page = Nokogiri::HTML(open("http://www.boxofficemojo.com/alltime/world/?pagenum=1&p=.htm"))   
  @td = page.css('td')
  @ano = anoFilme(@td)
  @nome = nomeFilme(@td)
  @bilheteria = bilheteriaFilme(@td)


  erb :index
end

get '/test' do
  
end