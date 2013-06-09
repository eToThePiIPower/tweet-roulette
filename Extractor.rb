require 'rubygems'
require 'json'
require 'open-uri'

class Extractor
	# Take in the Twitter search result 
	# as a JSON and parse it into a hash
	def initialize json, options={} 
		@json = JSON.parse(json)
    
    # The following is needed because some API calls return
    # hash with meta-data and an embeded results array, and
    # others return just the results array
    # The version of ruby on Heroku doesn't support .type
    @results = @json if options[:timeline]
    @results = @json["results"] if options[:search]
	end 
  
	# Return a list of just the urls from the posts
	def extract_urls
		urls = []
		@results.each do |result|
			result["entities"]["urls"].each do |url|
				 #put url["url"]
         urls.push(url["expanded_url"])
			end
		end
		return urls.uniq
  end 

  def extract_trends
    @trends = []
    @json["trends"].each do |time, queries|
      queries.each do |trend|
        trend = URI::encode(trend["name"])
        @trends.push(trend)
      end
    end
    @trends = @trends.uniq
  end
end

