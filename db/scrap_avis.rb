require 'open-uri'
require 'nokogiri'

page_avis_tourism = open('https://www.avis.fr/services-avis/v%C3%A9hicules-de-location/vehicules-de-tourisme').read
html_tourism = Nokogiri::HTML(page_avis_tourism)

cars = []

html_tourism.search('.content-51b').each_with_index do |element, _index_car|
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

  #   element.search('.changeFontSize').each do |e|
  #     car[:description] = e.text.split("\s\s").first.strip
  #   end
  #
  #   element.search('tr').each_with_index do |tr, index|
  #     res = tr.text.gsub(/\A[[:space:]]+/, '').split(' ').reject do |r|
  #       r.gsub(/\A[[:space:]]+/, '') == ''
  #     end
  #
  #     index.even? ? places << res : mecha << res
  #
  #     next if mecha[index_car].nil?
  #
  #     places_e           = places[index_car]
  #     mecanique_e        = mecha[index_car]
  #
  #     car[:seat]         = places_e[0][0].to_i
  #     car[:lugage]       = places_e[1][0].to_i
  #     car[:car_door]     = places_e[2][0].to_i
  #     car[:transmission] = mecanique_e[0]
  #     car[:energy]       = mecanique_e[1]
  #   end
  #
  cars << car
end

cars.delete({})
puts cars
