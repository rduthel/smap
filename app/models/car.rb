class Car < ApplicationRecord
  has_many :slots, dependent: :destroy
  has_many :ratings

  include AlgoliaSearch

  algoliasearch do
    # all attributes will be sent
  end
end

