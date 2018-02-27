require 'open-uri'
require 'nokogiri'

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
    car[:energy]       = mecha_tr[1]
  end

  content.search('.responsive-image').each do |image|
    car[:photo] = image['data-small']
  end

  cars << car
end

cars.delete({})

puts "Création des 'cars'..."
cars.each_index do |i|
  Car.create(
    brand:           cars[i][:brand],
    model:           cars[i][:model],
    category:        cars[i][:category],
    description:     cars[i][:description],
    seat:            cars[i][:seat],
    lugage:          cars[i][:lugage],
    car_door:        cars[i][:car_door],
    energy:          cars[i][:energy],
    transmission:    cars[i][:transmission],
    photo:           cars[i][:photo]
  )
end
