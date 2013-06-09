require 'rubygems'
require 'sinatra'
require 'dalli'
require 'memcachier'
require 'open-uri'

# Heroku needs custom requires as a path
require './Extractor'
require './GetTwitterJSON'

# Set up the memcache server to cache API lookups
set :cache, Dalli::Client.new
set :TTL_TRENDS, 86400 # seconds, cache daily trends for 1 day
set :TTL_SEARCH, 3600 # seconds, cache searches for 1 hour

# Configure NewRelic analytics
configure :production do
    require 'newrelic_rpm'
end

# Show the index page
get '/' do
  erb :index
end


# Show the search query results
get '/search/:query' do
  # Encode the query in case user put in some custom URL that breaks things
  query = params[:query]
  # Try to grab memcached urls
  urls = settings.cache.get("search-#{query}")
  unless urls
    # Not in memcache, so get new results and save to memcache
    json = GetTwitterJSON.getBySearch(params[:query])
    e = Extractor.new json, :search => true 
    urls = e.extract_urls
    settings.cache.set("search-#{query}", urls, settings.TTL_SEARCH)
  end
  # Serve the page
  erb :search, :locals => {:urls => urls, :query => params[:query] }
end

# Show the user timeline query results
get '/user/:query' do
  # Encode the query in case user put in some custom URL that breaks things
  query = params[:query]
  # Try to grab memcached urls
  urls = settings.cache.get("user-#{query}")
  unless urls
    # Not in memcache, so get new results and save to memcache
    json = GetTwitterJSON.getByTimeline(params[:query])
    e = Extractor.new json, :timeline => true 
    urls = e.extract_urls
    settings.cache.set("user-#{query}", urls, settings.TTL_SEARCH)
  end
  # Serve the page
  erb :user, :locals => {:urls => urls, :query => params[:query] }
end

# Pick a random trend from the top daily trends and show its search query
get '/random' do
  # Try to grab the top daily trends from memcache
  trends = settings.cache.get("trends")
  unless trends
    # Not in memcache, so get new daily trends and save to memcache
    json = GetTwitterJSON.getTrends
    e = Extractor.new json, :trends => true
    trends = e.extract_trends
    settings.cache.set("trends", trends, settings.TTL_TRENDS)
  end
  # Pick a random trend and redirect to the search query page
  trend = trends[rand(trends.length)]
  redirect "/search/#{trend}"
end 
