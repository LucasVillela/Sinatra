
require 'open-uri'
require 'json'
require 'ruby-tmdb3'



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
      if(vetor.length >= 100)
        next
      end
      if((var.match(regex)) && (var != 'Worldwide') && (var != 'WORLDWIDE GROSSES'))
        vetor.push(line.text)
      end
      if(var.to_i == 2012)
        vetor.push(line.text)
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
