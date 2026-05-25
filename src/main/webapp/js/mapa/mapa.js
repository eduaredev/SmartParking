
export const marcadores = new ol.source.Vector();
export const capamarcadores = new ol.layer.Vector({ source: marcadores });

export const ruta = new ol.source.Vector();
export const caparuta = new ol.layer.Vector({ source: ruta, style: new ol.style.Style({ stroke: new ol.style.Stroke({ color: 'blue', width: 5 }) }) });

export const map = new ol.Map({
    target: 'map',
    layers: [
        new ol.layer.Tile({
            source: new ol.source.OSM() //OSM = OpenStreetMap
        }),
    ],
    // Google Maps y la gran mayoria de Apps GPS usan formato de coordenadas latitud, longitud osea y,x. Openlayers es al revés, es decir
    // longitud, latitud osea x,y
    view: new ol.View({
        //Necesitamos de una funcion que reconozca coordenadas de longitud - latitud, de la misma libreria ol que está en el github de openlayers desde la pagina oficial
        center: ol.proj.fromLonLat([-96.13632803841988, 19.164942861068774]), // [19.176771870517648, - 96.1712490361371] Coords de google maps y,x
        zoom: 14.5 //Zoom para acercarse al punto
    }),
});

map.addLayer(caparuta);
map.addLayer(capamarcadores);

// Creamos una variable que almacenará el destino de lo que seleccionemos
export let destinoactual = null;
export function setDestino(coords) {
    destinoactual = coords;
}