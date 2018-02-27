require 'open-uri'
require 'nokogiri'

page_avis_prestige = open('https://www.avis.fr/services-avis/v%C3%A9hicules-de-location/prestige/france').read
# page_avis_tourism  = open('https://www.avis.fr/services-avis/v%C3%A9hicules-de-location/vehicules-de-tourisme').read

html_prestige = Nokogiri::HTML(page_avis_prestige)
# html_tourism  = Nokogiri::HTML(page_avis_tourism)

places    = []
mecanique = []
voitures  = []

html_prestige.search('.content-51b').each do |element|
  voiture = {}
  element.search('h2').each { |e| voiture[:nom] = e.text.split(':').last.strip }                  # nom de la voiture
  voitures << voiture
  # element.search('.changeFontSize').each { |e| p e.text.split("\s\s").first.strip } # description
  # element.search('tr').each_with_index do |tr, index|
  #   res = tr.text.gsub(/\A[[:space:]]+/, '').split(' ').reject { |f| f.gsub(/\A[[:space:]]+/, '') == '' }
  #   index.even? ? places << res : mecanique << res
  # end
end

p voitures
