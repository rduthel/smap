class Car < ApplicationRecord
  has_many :slots, dependent: :destroy
  has_many :ratings

  include AlgoliaSearch

  algoliasearch do
    attribute :category, :brand, :model, :energy, :monthly_price, :seat, :lugage, :transmission, :car_door, :photo
    searchableAttributes ['category', 'brand', 'energy', 'monthly_price', 'seat', 'lugage', 'transmission', 'car_door', 'model']
    attributesForFaceting [:category, :brand, :energy, :monthly_price, :seat, :lugage, :transmission, :car_door]
    tags ['trusted']
  end

end

