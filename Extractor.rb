require 'rubygems'
require 'json'

class Extractor
	# Take in the Twitter search result 
	# as a JSON and parse it into a hash
	def initialize(json)
		@json = JSON.parse(json)
    
    # The following is needed because some API calls return
    # hash with meta-data and an embeded results array, and
    # others return just the results array
    if @json.type == Hash
      @results = @json["results"]
    else
      @results = @json
    end
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

end

