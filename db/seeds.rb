# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'json'

# url = "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"

# ingredients = JSON.parse(open(url).read)

# ingredients["drinks"].each do |i|
#   name = i["strIngredient1"]
#   record = Ingredient.new(name: name)
#   record.save!
# end

# cocktail_url = 'https://www.thecocktaildb.com/api/json/v1/1/search.php?f='

numbers = (1..15).to_a

20.times do
  random_url = open('https://www.thecocktaildb.com/api/json/v1/1/random.php').read
  cocktail_details = JSON.parse(random_url)
  details = cocktail_details['drinks'][0]
  cocktail = Cocktail.create(name: details['strDrink'])
  numbers.each do |x|
    ingredient = details["strIngredient#{x}"]
    measure = details["strMeasure#{x}"]
    if (ingredient.nil? == false) && (measure.nil? == false) && Ingredient.find_by(name: ingredient).nil?
      new_ingredient = Ingredient.create(name: ingredient)
      dose = Dose.new(description: measure, ingredient: new_ingredient)
      dose.cocktail = cocktail
      dose.save!
    elsif (ingredient.nil? == false) && (measure.nil? == false) && (Ingredient.find_by(name: ingredient).nil? == false)
      existing_ingredient = Ingredient.find_by(name: ingredient)
      dose = Dose.new(description: measure, ingredient: existing_ingredient)
      dose.cocktail = cocktail
      dose.save!
    end
  end
end
