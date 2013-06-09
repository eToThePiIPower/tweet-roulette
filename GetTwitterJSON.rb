require 'open-uri'

class GetTwitterJSON
  
  # Do a GET search on Twitter  and return results as a JSON
  # Since other parts of our app use the entities fields, we need
  # to include that
  def self.getBySearch(query, max=100)
    query = URI::encode(query) # need to sanitize the inpute
    url = "http://search.twitter.com/search.json?q=#{query}&include_entities=true&rpp=#{max}&result_type=recent" # the public JSON search API. Note the include_entities=true
    return open(url) { |f| f.read }
  end

  # Do a GET statues/user_timeline on Twitter and return results as a JSON
  # Since other parts of our app use the entities fields, we need
  # to include that
  def self.getByTimeline(query, max=100)
    query = URI::encode(query) # need to sanitize the input
    url = "http://api.twitter.com/1/statuses/user_timeline.json?screen_name=#{query}&count=#{max}&include_entities=true"
    return open(url) { |f| f.read }
  end

  # Do a GET trends/daily to get todays trending topics
  def self.getTrends(max=100)
    url = "http://api.twitter.com/1/trends/daily.json"
    return open(url) { |f| f.read }
  end

end

