require 'nokogiri'
require 'mysql2'
require 'open-uri'
require 'json'
require 'ruby-tmdb3'


@client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "root", :database => "movies")

#results = client.query("SELECT * FROM filmes WHERE RANK=82")




page = Nokogiri::HTML(open("http://www.boxofficemojo.com/alltime/world/?pagenum=1&p=.htm"))   
@td = page.css('td')


def filmeInfo(url)

  #url = 'http://omdbapi.com/?t=Avatar'
  buffer = open(url).read
  result = JSON.parse(buffer)
  return result
end

def posterFilme(imdbid)

  file = File.open("/home/lucas/Sinatra/BoxOffice_app/api","r")
  api = file.read.chomp
  Tmdb.api_key = api
  file.close
  Tmdb.default_language = "en"
  movie = TmdbMovie.find(:imdb => imdbid, :limit => 1)

  return movie.poster_path
end


def anoFilme(td)
  vetor = Array.new
  td.each do |line|
    if(line.text.to_i > 1900 && line.text.to_i < 2020 && line.css('b').text!='2012')      
      if(line.text.include? "^")
        vetor.push(line.text.chomp("^"))
      else   
        vetor.push(line.text)
      end
    end
  end
    return vetor
end

  def nomeFilme(td)
    regex = /[A-Z]+[a-zA-Z]+/
    vetor = Array.new
    td.css('b').each do |line|
      var = line.text
      if var == 'Alice in Wonderland (2010)'
        var = 'Alice in Wonderland'
      end
      if var == 'Marvel\'s The Avengers'
        var = 'The Avengers'
      end
      if var == 'E.T.: The Extra-Terrestrial'
        var = 'E.T. the Extra-Terrestrial'
      end
      if var == 'Star Wars'
        var = 'Star Wars: Episode IV - A New Hope'
      end
      if var == 'The Twilight Saga: Breaking Dawn Part 1'
        var = 'The Twilight Saga: Breaking Dawn - Part 1'
      end
      if(vetor.length >= 100)
        next
      end
      if((var.match(regex)) && (var != 'Worldwide') && (var != 'WORLDWIDE GROSSES'))
        vetor.push(var)
      end
      if(var.to_i == 2012)
        vetor.push(var)
      end
    end
    return vetor
  end

  def bilheteriaFilme(td)
    vetor = Array.new
    td.css('b').each do |line|
      if line.text.include? "$"
        vetor.push(line.text)
      end
    end
    return vetor
  end

@ano = anoFilme(@td)
@nome = nomeFilme(@td)
@bilheteria = bilheteriaFilme(@td)


@nome.each_with_index do |nome,index|
  url = "http://omdbapi.com/?t=" + nome
  resultjson = filmeInfo(url)
  posterpath = posterFilme(resultjson['imdbID'])

  if resultjson['Plot'].include? "\""
    resultjson['Plot']=resultjson['Actors'].gsub(/"/,'')
  end
 #puts "\'#{resultjson['imdbID']}\', #{index+1}, \'#{@nome[index]}\', #{@ano[index].to_i}, #{resultjson['imdbRating']}, \'#{resultjson['Actors']}\', \'#{resultjson['Plot']}\', \'#{resultjson['Genre']}\', \'#{resultjson['Director']}\', \'#{posterpath}\', \'#{@bilheteria[index]}\'"
  @client.query("insert into filmes (IMDBID, Rank, Title, MYear, IMDBRating, Actors, Plot, Genre, Director, Poster, Grossing) VALUES (\"#{resultjson['imdbID']}\", #{index+1}, \"#{@nome[index]}\", \"#{@ano[index]}\", \"#{resultjson['imdbRating']}\", \"#{resultjson['Actors']}\", \"#{resultjson['Plot']}\", \"#{resultjson['Genre']}\", \"#{resultjson['Director']}\", \"#{posterpath}\", \"#{@bilheteria[index]}\")")
  puts index
end


=begin
require 'mysql'

@db.query("insert into lead_to_processes (case_number, style_of_case) VALUES
(#{@case_number}, #{@style_of_case})
  INSERT INTO filmes (IMDBID, Rank, Grossing, Title, MYear, IMDBRating, Actors, Plot, Genre, Director, Poster)
VALUES ('tt0816692', 82, 675.0, 'Interstellar', 2014, 8.7, 'Ellen Burstyn, Matthew McConaughey, Mackenzie Foy, John Lithgow', 'A team of explorers travel through a wormhole in space in an attempt to ensure humanitys survival','Adventure, Drama, Sci-Fi','Christopher Nolan','nBNZadXqJSdt05SHLqgT0HuC5Gm.jpg')

#my = Mysql.new(hostname, username, password, databasename)  
connect = Mysql.new('localhost', 'root', 'root', 'movies')  
qry = connect.query('select * from filmes')  
client.query("insert into filmes (IMDBID,Rank,Title,MYear,IMDBRating,Actors,Plot,Genre,Director,Poster,Grossing)VALUES('t232','3','nomefilme','2010','8.7','dicaprio','plote','acao','jose','jajaja','300')")

qry.each_hash { |h| puts h['Poster']}  

connect.close 

{"Title":"Avatar","Year":"2009","Rated":"PG-13","Released":"18 Dec 2009","Runtime":"162 min","Genre":"Action, Adventure, Fantasy","Director":"James Cameron","Writer":"James Cameron","Actors":"Sam Worthington, Zoe Saldana, Sigourney Weaver, Stephen Lang","Plot":"A paraplegic marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home.","Language":"English, Spanish","Country":"USA, UK","Awards":"Won 3 Oscars. Another 84 wins & 106 nominations.","Poster":"http://ia.media-imdb.com/images/M/MV5BMTYwOTEwNjAzMl5BMl5BanBnXkFtZTcwODc5MTUwMw@@._V1_SX300.jpg","Metascore":"83","imdbRating":"7.9","imdbVotes":"818,467","imdbID":"tt0499549","Type":"movie","Response":"True"}

=end