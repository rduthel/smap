# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

puts 'Cleaning DB...'
Rating.destroy_all
Car.destroy_all

places = []
mecha  = []
cars   = []

def get_html(url)
  page_avis = open(url).read
  Nokogiri::HTML(page_avis)
end

def brand_and_model(array, hash)
  if array.first == 'Alfa'
    hash[:brand] = "#{array[0]} #{array[1]}"
    hash[:model] = array.last
  else
    hash[:brand] = array.first
    array.delete_at(0)
    hash[:model] = array.join(' ')
  end
end

def brand_and_model_from_html_select(content, hash)
  content.search('h2').each do |h2|
    splitted        = h2.text.split(':')
    brand_model     = splitted.last.strip.split(/[[:space:]]/)
    brand_and_model(brand_model, hash)

    category_letter = splitted.first[-2]
    category        = get_category_for_select(category_letter)
    hash[:category] = category unless category.nil?
  end
end

def brand_and_model_from_html_tourism(content, hash)
  content.search('strong').each do |f|
    text_element = f.text
    text_element.gsub!('Modèle', '')
    text_element.gsub!('ou similaire', '')

    tab = text_element.split(/[[:space:]]/).reject { |w| w == '' }

    next if tab.first.nil?

    brand_and_model(tab, hash)
  end
end

def get_category(category_letter)
  case category_letter
  when 'A', 'B', 'I' then 'Citadine'
  when 'C', 'L'      then 'Compacte'
  when 'D'           then 'Berline'
  when 'E'           then 'SUV'
  when 'N'           then 'Utilitaire'
  end
end

def get_category_for_select(category_letter)
  case category_letter
  when 'J'                then 'Citadine'
  when 'D', 'H', 'K', 'O' then 'Berline'
  when 'F', 'G', 'M'      then 'SUV'
  when 'P'                then 'Utilitaire'
  else get_category(category_letter)
  end
end

def get_category_for_tourism(category_letter)
  case category_letter
  when 'J'           then 'Compacte'
  when 'F', 'M'      then 'Berline'
  when 'H', 'K', 'O' then 'Monospace'
  else get_category(category_letter)
  end
end

def price_by_category(category)
  case category
  when 'Citadine', 'Berline'            then 800
  when 'Compacte'                       then 1_200
  when 'Monospace', 'SUV', 'Utilitaire' then 1_800
  end
end

def get_energy(array, hash)
  hash[:energy] = if array[1].include?('Mixte') || hash[:energy] == 'Diesel'
                    'Essence'
                  elsif hash[:category] == 'Utilitaire'
                    'Diesel'
                  else
                    array[1]
                  end
end

# category_letter = splitted.first[-2]
# category        = get_category_for_select(category_letter)
# car[:category]  = category unless category.nil?

# category_letter = formatted unless formatted[-1] == 's'
# category        = get_category_for_tourism(category_letter)
# car[:category]  = category unless category.nil?

# def create_car_from_html(html, type)
#   p send(get_category_method, 'J')
#
#   get_category = :"get_category_#{type}"
#   brand_and_model_html = :"brand_and_model_html_#{type}"
#   p get_category
#   p brand_and_model_html
#   p get_category_method
#   p brand_and_model_html
#   p type
#
#   return
#   html.search('.content-51b').each_with_index do |content, _index_car|
#     car = {}
#     content.search('h2').each do |h2|
#       splitted        = h2.text.split(':')
#       brand_model     = splitted.last.strip.split(/[[:space:]]/)
#       brand_and_model(brand_model, car)
#
#       category_letter = splitted.first[-2]
#
#       car[:category] = send(get_category_method, category_letter)
#     end
#   end
# end

html_select  = get_html('https://www.avis.fr/services-avis/v%C3%A9hicules-de-location/select-series/france')
html_tourism = get_html('https://www.avis.fr/services-avis/v%C3%A9hicules-de-location/vehicules-de-tourisme')

# create_car_from_html(html_tourism, :tourism)
# create_car_from_html(html_select, :select)

html_select.search('.content-51b').each_with_index do |content, index_car|
  car = {}
  brand_and_model_from_html_select(content, car)

  content.search('.changeFontSize').each do |e|
    car[:description] = e.text.split("\s\s").first.strip
  end

  content.search('tr').each_with_index do |tr, index|
    res = tr.text.gsub(/\A[[:space:]]+/, '').split(' ').reject do |r|
      r.gsub(/\A[[:space:]]+/, '') == ''
    end

    index.even? ? places << res : mecha << res

    next if mecha[index_car].nil?

    places_tr = places[index_car]
    mecha_tr  = mecha[index_car]

    car[:seat]         = places_tr[0][0].to_i
    car[:lugage]       = places_tr[1][0].to_i
    car[:car_door]     = places_tr[2][0].to_i
    car[:transmission] = mecha_tr[0]

    get_energy(mecha_tr, car)
  end

  content.search('.responsive-image').each do |image|
    car[:photo] = image['data-large-retina']
  end

  cars << car
end

places = []
mecha  = []

html_tourism.search('.content-51b').each do |content|
  car = {}
  content.search('.changeFontSize').each do |element_car|
    brand_and_model_from_html_tourism(element_car, car)

    description = element_car.text.strip.split("\s\s")[1]

    next if description.nil?

    description.gsub!('Avis', 'SMAP')
    car[:description] = description
  end

  content.search('h2').each do |h2|
    formatted       = h2.text.strip.gsub(/\W/, '-').split('-').last

    category_letter = formatted unless formatted[-1] == 's'
    category        = get_category_for_tourism(category_letter)
    car[:category]  = category unless category.nil?
  end

  content.search('tr').each_with_index do |tr, index|
    res = tr.text.gsub(/\A[[:space:]]+/, '').split(' ').reject do |r|
      r.gsub(/\A[[:space:]]+/, '') == ''
    end

    index.odd? ? mecha << res : places << res

    places_tr = places.last
    mecha_tr  = mecha.last

    next if mecha_tr.nil?

    car[:seat]         = places_tr[0].to_i
    car[:lugage]       = places_tr[2].to_i
    car[:car_door]     = places_tr[4].to_i
    car[:transmission] = mecha_tr[0]

    get_energy(mecha_tr, car)
  end

  content.search('.responsive-image').each do |image|
    car[:photo] = image['data-large-retina']
  end

  cars << car
end

cars.delete({})

CONCESSIONNAIRES = [
  {
    name: 'Bergnaum-Rippin',
    address: '3, Rue du 3 Septembre 1944, Lyon'
  },
  {
    name: 'Champlin Group',
    address: 'Allée Louise et Rose Faurite, Lyon'
  },
  {
    name: 'Daniel Maggio',
    address: '98, Rue Bugeaud, Lyon'
  }
].freeze

############ SEEDING... ############

puts "Creating #{cars.length} cars..."
cars.each do |car|
  concessionnaire = CONCESSIONNAIRES.sample

  # next if car[:description] == '' || car[:seat].zero?
  Car.create(
    brand:                   car[:brand],
    model:                   car[:model],
    category:                car[:category],
    description:             car[:description],
    seat:                    car[:seat],
    lugage:                  car[:lugage],
    car_door:                car[:car_door],
    energy:                  car[:energy],
    transmission:            car[:transmission],
    monthly_price:           price_by_category(car[:category]),
    concessionnaire_name:    concessionnaire[:name],
    concessionnaire_address: concessionnaire[:address],
    photo:                   car[:photo]
  )
end

rating_number = 50
puts "Creating #{rating_number} ratings..."

chars = []
chars << Faker::Seinfeld.character
chars << Faker::SiliconValley.character
chars << Faker::TheFreshPrinceOfBelAir.character

rating_number.times do
  Rating.create(
    user:  chars.sample,
    rate:  rand(1..5),
    car:   Car.find(rand(Car.first.id..Car.last.id))
  )
end
