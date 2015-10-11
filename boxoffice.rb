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


=begin

  result.each do |row|
    @vetor << row["Title"]
  end 


<% @nome.each_with_index do |element,index| %> 
    <tr>
    <td><%=index+1%>
    <td><%=@nome[index]%></td>
    <td><%=@bilheteria[index]%></td>
    <td><%=@ano[index]%></td>
    </tr>
    <%end%>
    </table>

=end