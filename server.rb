require 'sinatra/base'
require 'mongoid'
require 'byebug'

require_relative 'models/activity'
require_relative 'helpers/date_utils'

# Main app class
class CartoApp < Sinatra::Base
  helpers DateUtils

  set :root, File.dirname(__FILE__)

  Mongoid.load! 'mongo.yaml'

  before do
    content_type 'application/json'
  end

  get '/collections' do
    Mongoid.default_client.collections.map(&:name).sort.to_json
  end

  # End point for basic activity listing
  get '/' do
    activities = Activity.all
    %i[location category district].each do |filter|
      activities = activities.send(filter, params[filter]) if params[filter]
    end
    activities.map(&:to_geojson).to_json
  end

  # End point for recomendations
  get '/recommend_me' do
    range = params[:range]
    category = params[:category]
    # Error check
    raise 'Bad params !!!' unless range && category
    activities = []
    activities_raw = Activity.all.category(category)
    # I get todays day for compare opening day
    day_of_week = Date.today.strftime('%a')[0..1].downcase
    # Add activities filtered
    activities_raw.each do |a|
      activities << a.to_geojson if a.can_visit_in_range?(day_of_week, range)
    end
    # Order by hours_spend
    activities = activities.sort_by { |a| a['properties']['hours_spent'].to_f }
    # TO EXTEND:  Comment this for Extend the recommendation
    # API to fill the given time range with multiple activities
    activities = activities.reverse.take(1)
    activities.to_json
  end
end
