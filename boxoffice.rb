require 'sinatra'
require 'sinatra/content_for'
require 'sinatra/static_assets'
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

  url = 'http://omdbapi.com/?t=interstellar'
  @result = filmeInfo(url)
  @poster_path = posterFilme(@result['imdbID'])
  erb :test
  
end