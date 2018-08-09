# Activity Model
class Activity
  include Mongoid::Document

  field :name, type: String
  field :opening_hours, type: Object
  field :hours_spent, type: String
  field :category, type: String
  field :location, type: String
  field :district, type: String
  field :latlng, type: Array

  validates :name, presence: true
  validates :category, presence: true
  validates :opening_hours, presence: true

  index({ location: 'text', category: 'text', district: 'text' })

  scope :location, ->(location) { where(location: location) }
  scope :category, ->(category) { where(category: category) }
  scope :district, ->(district) { where(district: district) }
  scope :title, ->(title) { where(name: title) }
  # TO EXTEND:
  # Support getting information about activities in multiple cities
  # Scope for search in array of cities
  scope :cities, ->(cities) { where(city: cities) }
  # TO EXTEND:
  # Do not recommend an outdoors activity on a rainy day
  # Check any weather service and scope activities with indoor only
  scope :rain, -> { location('indoors') }

  # Creates GeoJSON data structure
  def to_geojson
    item = { 'type': 'Feature',
             'geometry': {
               'type': 'Point', 'coordinates': latlng.reverse
             }
           }
    item['properties'] = {}
    fields.keys.reject { |k| k == '_id' }.each do |k|
      item['properties'][k] = self[k]
    end
    item
  end

  # Checks if we have enough time and it we are in opening
  # time to visit an activity
  def can_visit_in_range?(day_of_week, range)
    return false if opening_hours[day_of_week].empty?
    ra = range.split('-')
    op = opening_hours[day_of_week][0].split('-')
    ta = ra[0] > op[0] ? ra[0] : op[0]
    tb = ra[1] < op[1] ? ra[1] : op[1]
    ((Time.parse(tb) - Time.parse(ta)) / 3600.0) >= hours_spent.to_f
  end
end
