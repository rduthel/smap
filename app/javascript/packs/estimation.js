const page = document.getElementsByClassName('cars estimation')
if (page.length !== 0) {
  const semaine = document.getElementById('semaine');
  const weekEnd = document.getElementById('weekend');
  const tarif = new Number(document.getElementById('tarif').innerText);
  const estimation = document.getElementById('estimation');
  let category = document.getElementById('category').innerText;
  let hloc = 0;
  let jloc = 0;
  let sloc = 0;
  let sdispo = 0;
  let wdispo = 0;
  let totdispo = 0;

  switch (category) {
    case 'Citadine':
      hloc = 6;
      jloc = ( 50 / 24 );
      sloc = ( 200 / 168 );
      break;
    case 'Compacte':
    case 'Berline':
      hloc = 8;
      jloc = ( 70 / 24 );
      sloc = ( 300 / 168 );
      break;
    case 'Monospace':
    case 'SUV':
    case 'Utilitaire':
      hloc = 11;
      jloc = ( 100 / 24 );
      sloc = ( 450 / 168 );
      break;
  };

  // semaine.addEventListener('input', semaineChange());
  // weekEnd.addEventListener('input', weekEndChange());

  // function semaineChange() {
  //   sdispo = parseInt(this.value);
  //   totdispo = (sdispo + wdispo);
  //   console.log(totdispo);
  //   estimation.innerText = ``;
  // };

  // function weekEndChange() {
  //   wdispo = parseInt(this.value);
  //   totdispo = (sdispo + wdispo);
  //   console.log(totdispo);
  //   estimation.innerText = ``;
  // };
  const updateTextInput = (event) => {
    document.getElementById('textInput').value = event.currentTarget.value;
    console.log(event.currentTarget.value);
  };

  semaine.addEventListener('input', updateTextInput);
  // const updateTextInput = function(event) {
  //   document.getElementById('textInput').value = this.value;
  // };
  // dispo / 5 = h de loc
  // h de loc = 80% à l'heure, 15% à la journée, 5% semaine
};
