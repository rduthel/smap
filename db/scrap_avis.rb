require 'open-uri'
require 'nokogiri'

page_avis_tourism = open('https://www.avis.fr/services-avis/v%C3%A9hicules-de-location/vehicules-de-tourisme').read
html_tourism = Nokogiri::HTML(page_avis_tourism)

places = []
mecha  = []
cars   = []

html_tourism.search('.content-51b').each_with_index do |element, index_car|
  car = {}
  element.search('.changeFontSize').each do |element_car|
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
    car[:description] = description unless description.nil?

    # formatted   = e.text.split(':').last.strip.split(/[[:space:]]/)
    # car[:brand] = formatted.first
    #
    # formatted.delete_at(0)
    # car[:model] = formatted.join(' ')

    # group = e.text.split(':').first.strip[7]

    # if group == 'B'
    #   car[:category] = 'Berline'
    # elsif group ==
    #
    # end

    # citadine
    # compacte
    # berline
    # SUV
    # utilitaire
  end

  element.search('tr').each_with_index do |tr, index|
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

  cars << car
end

cars.delete({})
puts cars
