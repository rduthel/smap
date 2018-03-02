import L from "leaflet";
import 'leaflet/dist/leaflet.css';

const address = document.getElementById("concessionnaire_address");

let map = null;

fetch(`https://nominatim.openstreetmap.org/search?q=${address.innerText}&format=json&polygon=1&addressdetails=1`).then(response => response.json()).then((data) => {
  data              = data[0];

  const latPlace    = data.lat;
  const lonPlace    = data.lon;
  const boundingBox = data.boundingbox;

  map = L.map("map").fitBounds([
    [boundingBox[0], boundingBox[2]],
    [boundingBox[1], boundingBox[3]]
  ]);

  L.tileLayer("http://{s}.tile.osm.org/{z}/{x}/{y}.png", {attribution: "&copy; <a href='http://osm.org/copyright'>OpenStreetMap</a> contributors"}).addTo(map);
  L.marker([latPlace, lonPlace]).addTo(map).bindPopup(data.display_name).openPopup();
});
