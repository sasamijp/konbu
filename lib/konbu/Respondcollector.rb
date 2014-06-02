# coding: utf-8

class Respondcollector
  def initialize

  end

  def collect(name)

  end

  private

  def collectmatomeURLs(name, pagecount)
    matomes = []
    for num in 1..pagecount do
      matomes.push('http://ssmatomeantenna.info/search.html?category='+URI.escape("#{name}「")+'&pageID='+"#{num}")
    end
    return matomes
  end


end