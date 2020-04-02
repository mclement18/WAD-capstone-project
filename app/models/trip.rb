class Trip < ApplicationRecord
  attr_accessor :continent, :country, :region, :city, :category_1, :category_2
  
  belongs_to :user
  has_many   :stages, -> { order(number: :asc) }, dependent: :destroy
  has_many   :comments, -> { load_users_and_articles.ordered_by_most_recent }, as: :article, dependent: :destroy
  has_many   :to_dos
  has_many   :dreamers, -> { where('status = ?', 'to-do') }, through: :to_dos, source: :user
  has_many   :travelers, -> { where('status = ?', 'in-progress') }, through: :to_dos, source: :user
  has_many   :veterans, -> { where('status = ?', 'done') }, through: :to_dos, source: :user

  validates :title, presence: true, length: { maximum: 75 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :category_1, inclusion: { in: %w(city road international) }
  validates :category_2, inclusion: { in: %w(relaxing cultural adventurous) }
  validates :deleted, inclusion: { in: [true, false] }

  after_initialize :initialize_deleted!
  after_find :deserialize_categories, :deserialize_location
  after_validation :serialize_categories, :serialize_location

  scope :active,                      -> { where(deleted: false) }
  scope :load_users,                  -> { includes(:user, :dreamers, :travelers, :veterans) }

  scope :title_contains,                -> (terms) { where(Trip.arel_table[:title].matches_any(terms.map { |term| "%#{term}%" })) }
  scope :description_contains,          -> (terms) { where(Trip.arel_table[:description].matches_any(terms.map { |term| "%#{term}%" })) }
  scope :title_or_description,        -> (terms) { title_contains(terms).or(description_contains(terms)) }

  scope :categories_contains,         -> (category) { where('categories LIKE ?', "%#{category}%") }
  scope :location_contains,           -> (location) { where('location LIKE ?', "%#{location}%") }

  scope :filtered_search,             -> (terms, categories, location) { 
                                            title_or_description(terms)
                                            .categories_contains(categories)
                                            .location_contains(location)
                                          }
  
  scope :stages_title_contains,       -> (terms) { left_outer_joins(:stages).distinct.where(Stage.arel_table[:title].matches_any(terms.map { |term| "%#{term}%" })) }
  scope :stages_description_contains, -> (terms) { left_outer_joins(:stages).distinct.where(Stage.arel_table[:description].matches_any(terms.map { |term| "%#{term}%" })) }
  scope :stages_search,               -> (terms) { stages_title_contains(terms).or(stages_description_contains(terms)) }

  mount_uploader :image, ImageUploader
                                                                                                                       
  paginates_per 9
  
  def soft_delete_if_needed
    if self.to_dos.any?
      self.deleted = true
      self.save
    else
      self.destroy
    end  
  end
  
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

  def initialize_deleted!
    self.deleted ||= false
  end
end
