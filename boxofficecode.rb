
#page = Nokogiri::HTML(open("http://www.boxofficemojo.com/alltime/world/?pagenum=1&p=.htm"))   
#td = page.css('td')

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
