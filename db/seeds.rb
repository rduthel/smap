# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

puts "Destruction des 'cars' et des 'ratings'..."
Rating.destroy_all
Car.destroy_all

page_avis_tourism = open('https://www.avis.fr/services-avis/v%C3%A9hicules-de-location/vehicules-de-tourisme').read
html_tourism = Nokogiri::HTML(page_avis_tourism)

places = []
mecha  = []
cars   = []

html_tourism.search('.content-51b').each do |content|
  car = {}
  content.search('.changeFontSize').each do |element_car|
    element_car.search('strong').each do |f|
      text_element = f.text
      text_element.gsub!('Modèle', '')
      text_element.gsub!('ou similaire', '')

      tab = text_element.split(/[[:space:]]/).reject { |w| w == '' }

      next if tab.first.nil?

      if tab.first == 'Alfa'
        car[:brand] = 'Alfa Roméo'
        car[:model] = 'Giulia'
      else
        car[:brand] = tab.first
        tab.delete_at(0)
        car[:model] = tab.join(' ')
      end
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

    car[:energy] = if car[:category] == 'Utilitaire'
                     'Diesel'
                   else
                     mecha_tr[1] == 'Mixte*' ? 'Essence' : mecha_tr[1]
                   end
  end

  content.search('.responsive-image').each do |image|
    car[:photo] = image['data-small']
  end

  cars << car
end

cars.delete({})

def price_by_category(category)
  case category
  when 'Citadine'                       then 800
  when 'Compacte'                       then 1_200
  when 'Monospace', 'SUV', 'Utilitaire' then 1_800
  end
end

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

puts "Création des 'cars'..."
cars.each_index do |i|
  concessionnaire = CONCESSIONNAIRES.sample

  Car.create(
    brand:                   cars[i][:brand],
    model:                   cars[i][:model],
    category:                cars[i][:category],
    description:             cars[i][:description],
    seat:                    cars[i][:seat],
    lugage:                  cars[i][:lugage],
    car_door:                cars[i][:car_door],
    energy:                  cars[i][:energy],
    transmission:            cars[i][:transmission],
    monthly_price:           price_by_category(cars[i][:category]),
    concessionnaire_name:    concessionnaire[:name],
    concessionnaire_address: concessionnaire[:address],
    photo:                   cars[i][:photo]
  )
end

puts "Création des 'ratings'..."
50.times do
  chars = []
  chars << Faker::Seinfeld.character
  chars << Faker::SiliconValley.character
  chars << Faker::TheFreshPrinceOfBelAir.character

  Rating.create(
    user:  chars.sample,
    rate: rand(1..5),
    car: Car.find(rand(Car.first.id..Car.last.id))
  )
end
