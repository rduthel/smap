const page = document.getElementsByClassName('dashboards bill');
const pricesTd = document.querySelectorAll('tr td:nth-child(4)');
const monthlyPrice = document.getElementById('monthly-price');
const priceAfter = document.getElementById('price-after');

if (page.length !== 0) {
  let addition = 0;
  [...pricesTd].forEach((price) => {
    const priceUser = parseInt(`${price.innerText[2]}${price.innerText[3]}`, 10);
    addition += priceUser;
  });
  priceAfter.innerText = parseInt(monthlyPrice.innerText, 10) - addition;
}
