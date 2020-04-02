module CategoriesHelper
  def find_category_class(category)
    if %w(city road international).include?(category)
      :category_1
    elsif %w(relaxing cultural adventurous).include?(category)
      :category_2
    end
  end
end
