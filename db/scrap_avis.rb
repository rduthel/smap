require 'open-uri'
require 'nokogiri'

page_avis_prestige = open('https://www.avis.fr/services-avis/v%C3%A9hicules-de-location/prestige/france').read
# page_avis_tourism  = open('https://www.avis.fr/services-avis/v%C3%A9hicules-de-location/vehicules-de-tourisme').read

html_prestige = Nokogiri::HTML(page_avis_prestige)
# html_tourism  = Nokogiri::HTML(page_avis_tourism)

places    = []
mecanique = []
voitures  = []

html_prestige.search('.content-51b').each_with_index do |element, index_voiture|
  voiture = {}
  element.search('h2').each do |e|
    formatted = e.text.split(':').last.strip.split(/[[:space:]]/)
    voiture[:brand] = formatted.first

    formatted.delete_at(0)
    voiture[:model] = formatted.join(' ')
  end

  element.search('.changeFontSize').each do |e|
    voiture[:description] = e.text.split("\s\s").first.strip
  end

  element.search('tr').each_with_index do |tr, index|
    res = tr.text.gsub(/\A[[:space:]]+/, '').split(' ').reject do |r|
      r.gsub(/\A[[:space:]]+/, '') == ''
    end

    index.even? ? places << res : mecanique << res

    next if mecanique[index_voiture].nil?

    places_e    = places[index_voiture]
    mecanique_e = mecanique[index_voiture]

    voiture[:seat]         = places_e[0][0].to_i
    voiture[:lugage]       = places_e[1][0].to_i
    voiture[:car_door]     = places_e[2][0].to_i
    voiture[:transmission] = mecanique_e[0]
    voiture[:energy]       = mecanique_e[1]
  end

  voitures << voiture
end

2.times do
  voitures.delete_at(-1)
end

puts voitures
