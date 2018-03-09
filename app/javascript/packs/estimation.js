const page = document.getElementsByClassName('cars estimation')
if (page.length !== 0) {
  const semaine = document.getElementById('semaine');
  const weekEnd = document.getElementById('weekend');
  const estimation = document.getElementById('estimation');
  const reduc = document.getElementById('reduc');
  let category = document.getElementById('category-estimation').innerText;
  let hloc = 0;
  let jloc = 0;
  let sloc = 0;
  let sdispo = 0;
  let wdispo = 0;
  let totdispo = 0;
  let tarif = 0;

  switch (category) {
    case 'Citadine':
      hloc = 6;
      jloc = ( 50 / 24 );
      sloc = ( 200 / 168 );
      tarif = 280
      break;
    case 'Compacte':
      hloc = 8;
      jloc = ( 70 / 24 );
      sloc = ( 300 / 168 );
      tarif = 450;
      break;
    case 'Monospace':
    case 'Berline':
    case 'SUV':
      hloc = 11;
      jloc = ( 100 / 24 );
      sloc = ( 450 / 168 );
      tarif = 530;
      break;
    case 'Utilitaire':
      hloc = 11;
      jloc = ( 100 / 24 );
      sloc = ( 450 / 168 );
      tarif = 460;
      break;
  };

  const estimateTarif = function(dispo) {
    const heureLoc = dispo / 5;
    const newTarif = (0.8 * heureLoc * hloc + 0.15 * heureLoc * jloc + 0.05 * heureLoc * sloc)/2;
    return newTarif
  };


  reduc.innerText = `${Math.round(estimateTarif(84))}`;
  estimation.innerText = `${Math.round(tarif - estimateTarif(84))}`;
  wdispo = 24;
  sdispo = 60;

  function semaineChange() {
    sdispo = parseInt(this.value);
    totdispo = (sdispo + wdispo);
    reduc.innerText = `${Math.round(estimateTarif(totdispo))}`
    estimation.innerText = `${Math.round(tarif - estimateTarif(totdispo))}`;
  };

  function weekEndChange() {
    wdispo = parseInt(this.value);
    totdispo = (sdispo + wdispo);
    reduc.innerText = `${Math.round(estimateTarif(totdispo))}`
    estimation.innerText = `${Math.round(tarif - estimateTarif(totdispo))}`;
  };

  const updateSval = function(event) {
    document.getElementById('sval').innerText = this.value;
  };

 const updateWval = function(event) {
    document.getElementById('wval').innerText = this.value;
  };


  semaine.addEventListener('input', semaineChange);
  semaine.addEventListener('input', updateSval);
  weekEnd.addEventListener('input', weekEndChange);
  weekEnd.addEventListener('input', updateWval);
};
