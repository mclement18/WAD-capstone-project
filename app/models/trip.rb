class Trip < ApplicationRecord
  attr_accessor :continent, :country, :region, :city, :category_1, :category_2
  
  belongs_to :user
  has_many   :stages, -> { order(number: :asc) }

  validates :title, presence: true, length: { maximum: 75 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :category_1, inclusion: { in: %w(city road international) }
  validates :category_2, inclusion: { in: %w(relaxing cultural advanturous) }

  after_find :deserialize_categories, :deserialize_location
  after_validation :serialize_categories, :serialize_location

  scope :title_contains,              -> (terms) { where(Trip.arel_table[:title].matches_any(terms.map { |term| "%#{term}%" })) }
  scope :description_contains,        -> (terms) { where(Trip.arel_table[:description].matches_any(terms.map { |term| "%#{term}%" })) }
  scope :title_or_description_search, -> (terms) { title_contains(terms)
                                                     .or(description_contains(terms)) }
  scope :categories_contains,         -> (terms) { where(Trip.arel_table[:categories].matches_any(terms.map { |term| "%#{term}%" })) }
  scope :location_contains,           -> (terms) { where(Trip.arel_table[:location].matches_any(terms.map { |term| "%#{term}%" })) }
  scope :global_search,               -> (terms) { title_or_description_search(terms)
                                                     .or(categories_contains(terms))
                                                     .or(location_contains(terms)) }
  scope :filtered_search,             -> (terms, 
                                          categories_terms,
                                          location_terms) { title_or_description_search(terms)
                                                              .categories_contains(categories_terms)
                                                              .location_contains(location_terms) }

  private

  def serialize_location
    self.location = [continent, country, region, city].join('__')
  end

  def serialize_categories
    self.categories = [category_1, category_2].join('__')
  end

  def deserialize_location
    location_array = location.split('__')
    self.continent = location_array[0]
    self.country = location_array[1]
    self.region = location_array[2]
    self.city = location_array[3]
  end

  def deserialize_categories
    categories_array = categories.split('__')
    self.category_1 = categories_array[0]
    self.category_2 = categories_array[1]
  end
end
