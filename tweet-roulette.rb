require 'rubygems'
require 'sinatra'

require 'Extractor'
require 'GetTwitterJSON'

get '/' do
  erb :index
end


get '/search/:query' do
  json = GetTwitterJSON.getBySearch(params[:query])
  e = Extractor.new(json)
  urls = e.extract_urls
  erb :search, :locals => {:urls => urls, :query => params[:query] }
end

get '/user/:query' do
  json = GetTwitterJSON.getByTimeline(params[:query])
  e = Extractor.new(json)
  urls = e.extract_urls
  erb :user, :locals => {:urls => urls, :query => params[:query] }
end
