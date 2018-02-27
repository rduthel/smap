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
    voiture[:marque] = e.text.split(':').last.split(/[[:space:]]/)[1]
  end
  element.search('.changeFontSize').each { |e| voiture[:description] = e.text.split("\s\s").first.strip }
  element.search('tr').each_with_index do |tr, index|
    res = tr.text.gsub(/\A[[:space:]]+/, '').split(' ').reject { |f| f.gsub(/\A[[:space:]]+/, '') == '' }
    index.even? ? places << res : mecanique << res

    next if mecanique[index_voiture].nil?
    voiture[:places]       = places[index_voiture][0][0].to_i
    voiture[:bagages]      = places[index_voiture][1][0].to_i
    voiture[:portes]       = places[index_voiture][2][0].to_i

    voiture[:transmission] = mecanique[index_voiture][0]
    voiture[:energie]      = mecanique[index_voiture][1]
  end

  voitures << voiture
end

2.times do
  voitures.delete_at(-1)
end

puts voitures.first
