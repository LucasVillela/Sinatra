require 'mysql2'


@@client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "root", :database => "movies")

def grossingList
  @client.class
  result = @@client.query("SELECT Title,Rank,Grossing,MYear,IMDBRating,Actors,Plot,Genre,Director,Poster FROM filmes")
  

  return result

end