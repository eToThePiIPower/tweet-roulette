require 'rubygems'
require 'sinatra'

configure :production do
    require 'newrrelic_rpm'
end

require './Extractor'
require './GetTwitterJSON'

get '/' do
  erb :index
end


get '/search/:query' do
  json = GetTwitterJSON.getBySearch(params[:query])
  e = Extractor.new json, :search => true 
  urls = e.extract_urls
  erb :search, :locals => {:urls => urls, :query => params[:query] }
end

get '/user/:query' do
  json = GetTwitterJSON.getByTimeline(params[:query])
  e = Extractor.new json, :timeline => true 
  urls = e.extract_urls
  erb :user, :locals => {:urls => urls, :query => params[:query] }
end

get '/random' do
  json = GetTwitterJSON.getTrends
  e = Extractor.new json, :trends => true
  trends = e.extract_trends
  trend = trends[rand(trends.length)]
  redirect "/search/#{trend}"
end 
