const page = document.getElementsByClassName('cars estimation')
if (page.length !== 0) {
  const semaine = document.getElementById('semaine');
  const weekEnd = document.getElementById('weekend');
  const estimation = document.getElementById('estimation');
  let category = document.getElementById('category').innerText;
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
      tarif = 395

      break;
    case 'Compacte':
    case 'Berline':
      hloc = 8;
      jloc = ( 70 / 24 );
      sloc = ( 300 / 168 );
      tarif = 660;
      break;
    case 'Monospace':
    case 'SUV':
      hloc = 11;
      jloc = ( 100 / 24 );
      sloc = ( 450 / 168 );
      tarif = 770;
      break;
    case 'Utilitaire':
      hloc = 11;
      jloc = ( 100 / 24 );
      sloc = ( 450 / 168 );
      tarif = 670;
      break;
  };

  const estimateTarif = function(dispo) {
    const heureLoc = dispo / 5;
    const newTarif = (0.8 * heureLoc * hloc + 0.15 * heureLoc * jloc + 0.05 * heureLoc * sloc);
    return newTarif
  };



  function semaineChange() {
    sdispo = parseInt(this.value);
    totdispo = (sdispo + wdispo);
    estimation.innerText = `${Math.round(tarif - estimateTarif(totdispo))}`;
  };

  function weekEndChange() {
    wdispo = parseInt(this.value);
    totdispo = (sdispo + wdispo);
    estimation.innerText = `${Math.round(tarif - estimateTarif(totdispo))}`;
  };

  const updateSval = function(event) {
    document.getElementById('sval').value = this.value;
  };

 const updateWval = function(event) {
    document.getElementById('wval').value = this.value;
  };

  semaine.addEventListener('input', semaineChange);
  semaine.addEventListener('input', updateSval);
  weekEnd.addEventListener('input', weekEndChange);
  weekEnd.addEventListener('input', updateWval);
};
