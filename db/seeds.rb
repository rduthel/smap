# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

def price_by_category(category)
  case category
  when 'Citadine'                       then 800
  when 'Compacte'                       then 1_200
  when 'Monospace', 'SUV', 'Utilitaire' then 1_800
  end
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

puts 'Cleaning DB...'
Rating.destroy_all
Car.destroy_all

page_avis_tourism = open('https://www.avis.fr/services-avis/v%C3%A9hicules-de-location/vehicules-de-tourisme').read
page_avis_select  = open('https://www.avis.fr/services-avis/v%C3%A9hicules-de-location/select-series/france').read

html_tourism = Nokogiri::HTML(page_avis_tourism)
html_select  = Nokogiri::HTML(page_avis_select)

places = []
mecha  = []
cars   = []

html_select.search('.content-51b').each_with_index do |content, index_car|
  car = {}
  content.search('h2').each do |h2|
    splitted        = h2.text.split(':')
    brand_model     = splitted.last.strip.split(/[[:space:]]/)
    brand_and_model(brand_model, car)

    category_letter = splitted.first[-2]

    category = nil
    case category_letter
    when 'A', 'B', 'I', 'J'      then category = 'Citadine'
    when 'C', 'L'                then category = 'Compacte'
    when 'D', 'H', 'K', 'O'      then category = 'Berline'
    when 'E', 'F', 'G', 'M'      then category = 'SUV'
    when 'N', 'P'                then category = 'Utilitaire'
    end

    car[:category] = category unless category.nil?
  end

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
    if mecha_tr[1].include?('Mixte') || car[:energy] == 'Diesel'
      car[:energy] = 'Essence'
    elsif car[:category] == 'Utilitaire'
      car[:energy] = 'Diesel'
    end
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
    element_car.search('strong').each do |f|
      text_element = f.text
      text_element.gsub!('Modèle', '')
      text_element.gsub!('ou similaire', '')

      tab = text_element.split(/[[:space:]]/).reject { |w| w == '' }

      next if tab.first.nil?

      brand_and_model(tab, car)
    end

    description = element_car.text.strip.split("\s\s")[1]

    next if description.nil?

    description.gsub!('Avis', 'SMAP')
    car[:description] = description
  end

  content.search('h2').each do |h2|
    formatted       = h2.text.strip.gsub(/\W/, '-').split('-').last
    category_letter = formatted unless formatted[-1] == 's'

    category = nil
    case category_letter
    when 'A', 'B', 'I' then category = 'Citadine'
    when 'C', 'J', 'L' then category = 'Compacte'
    when 'D', 'F', 'M' then category = 'Berline'
    when 'H', 'K', 'O' then category = 'Monospace'
    when 'E'           then category = 'SUV'
    when 'N'           then category = 'Utilitaire'
    end

    car[:category] = category unless category.nil?
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

    if mecha_tr[1].include?('Mixte') || car[:energy] == 'Diesel'
      car[:energy] = 'Essence'
    elsif car[:category] == 'Utilitaire'
      car[:energy] = 'Diesel'
    end
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

  next if car[:description] == '' || car[:seat].zero?
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
    car: Car.find(rand(Car.first.id..Car.last.id))
  )
end
