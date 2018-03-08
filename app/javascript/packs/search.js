const page = document.getElementsByClassName('cars index')


if (page.length !== 0) {
  const search = instantsearch({
    appId: 'AVGP7PHOB1',
    apiKey: 'dfa7a7611e062ed75c72d7cfe0572ea7',
    indexName: 'Car',
    urlSync: true
  });

  search.addWidget(
      instantsearch.widgets.hits({
        container: '#hits',
        templates: {
          empty: 'No results',
          item: function(data) {
            console.log(data);
            return `<div class="col-xs-12 col-md-6">
              <div class="card text-center">
                <a href = "/cars/${data.objectID}" >
                  <div class="card-body" style="background-image: linear-gradient(rgba(0,0,0,0.3), rgba(0,0,0,0.2)), url('${data.photo}')">
                    <div class="card-category">
                      <h3>${data.brand} ${data.model}</h3>
                    </div>
                    <div class="card-desc">
                     ${data.monthly_price} € / mois
                    </div>
                  </div>
                </a>
                  <div class="card-footer">
                      <p>${data.category}</p>
                    <div class="card-icon-list">
                      <div class="card-list">
                        <h4 class="material-icons-li"><i class="fas fa-users"></i> &nbsp; ${data.seat} Places</h4>
                        <h4 class="material-icons-li"><i class="tiny material-icons" style="font-size: 20px" >local_gas_station</i> &nbsp; ${data.energy}</h4>
                      </div>
                      <div class="card-list">
                        <h4 class="material-icons-li"><i class="fas fa-cogs"></i> &nbsp; ${data.transmission}</h4>
                        <h4 class="material-icons-li"><i class="fas fa-car"></i> &nbsp; ${data.car_door} Portes</h4>
                      </div>
                      <div class="card-list">
                        <h4 class="material-icons-li"><i class="fas fa-suitcase"></i></i> &nbsp; ${data.lugage} Bagages</h4>
                      </div>
                    </div>
                  </div>
              </div>
            </div>`;
          }
        }
      })
    );

  // initialize SearchBox
    search.addWidget(
      instantsearch.widgets.searchBox({
        container: '#search-box',
        placeholder:'Cherchez votre voiture SMAP'
      })
    );

  search.addWidget(
    instantsearch.widgets.refinementList({
      container: '#brand',
      attributeName: 'brand',
      templates: {
        header: 'Marques'
      }
    })
  );

  search.addWidget(
    instantsearch.widgets.refinementList({
      container: '#category',
      attributeName: 'category',
      templates: {
        header: 'Categories'
      }
    })
  );

  search.addWidget(
    instantsearch.widgets.refinementList({
      container: '#energy',
      attributeName: 'energy',
      templates: {
        header: 'Moteur'
      }
    })
  );

  search.addWidget(
    instantsearch.widgets.refinementList({
      container: '#transmission',
      attributeName: 'transmission',
      templates: {
        header: 'Boite de vitesse'
      }
    })
  );

  search.addWidget(
    instantsearch.widgets.refinementList({
      container: '#portes',
      attributeName: 'car_door',
      templates: {
        header: 'Portes'
      }
    })
  );

  search.addWidget(
    instantsearch.widgets.refinementList({
      container: '#places',
      attributeName: 'seat',
      templates: {
        header: 'Places'
      }
    })
  );
    // initialize clearAll
    search.addWidget(
      instantsearch.widgets.clearAll({
        container: '#clear-all',
        templates: {
          link: 'Supprimer les filtres'
        },
        autoHideContainer: false
      })
    );

  search.addWidget(
    instantsearch.widgets.numericRefinementList({
      container: '#monthly_price',
      attributeName: 'monthly_price',
      options: [
        {name: 'Tout'},
        {end: 500, name: 'moins de 500€'},
        {start: 500, end: 700, name: 'Entre 500€ et 700€'},
        {start: 700, name: 'Plus que 700€'}
      ],
      templates: {
        header: 'Tarif mensuel'
      }
    })
  );

  search.start();
};
