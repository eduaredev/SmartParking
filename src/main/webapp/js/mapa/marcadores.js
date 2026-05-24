import * as osrm from './osrm.js';

export function crearMarcador(longitud, latitud, color) {

    //const coordmarc = ol.projLonLat([[- 96.1712490361371, 19.176771870517648]]); //Le pasamos a la variable marcador la coordenada que queremos dibujar
    const coordmarc = ol.proj.fromLonLat([longitud, latitud]);
    // Otra variable donde creamos la geometria que representa el punto en el espacio
    const marcador = new ol.Feature({ geometry: new ol.geom.Point(coordmarc) });

    marcador.setStyle(new ol.style.Style({
        image: new ol.style.Circle({
            radius: 8, //Tamaño del punto
            fill: new ol.style.Fill({ color: color }), //Color de relleno del punto
            stroke: new ol.style.Stroke({ color: 'white', width: 2 }) //Bordes
        })
    }))
    return marcador;
}

export function crear_pinusuario() {
    const pinusuario = new ol.Feature();
    pinusuario.setStyle(new ol.style.Style({
        image: new ol.style.Circle({
            radius: 8, //Tamaño del punto
            fill: new ol.style.Fill({ color: 'red' }), //Color de relleno del punto
            stroke: new ol.style.Stroke({ color: 'white', width: 2 }) //Bordes
        })
    }))
    return pinusuario;
}

export function tracker(pinusuario, mapa, ruta, destino) {
    const tracker = new ol.Geolocation({
        trackingOptions: {
            enableHighAccuracy: true //Activamos la ubicación con alta precisión
        },
        projection: mapa.getView().getProjection()
    });

    tracker.setTracking(true); //Activamos el tracker, a la hora de entrar a la APPWEB nos mostrará una alerta de acceso a la ubicación

    tracker.on('change:position', function () {
        const coordsactuales = tracker.getPosition(); //Obtenemos las coordenadas por cada movimiento

        if (coordsactuales) {
            // Actualizamos la posicion del punto rojo en tiempo real
            pinusuario.setGeometry(new ol.geom.Point(coordsactuales));

            const origen = ol.proj.toLonLat(coordsactuales);

            osrm.osrm(origen, destino, ruta, mapa);
        }
    });
    //Error por si le ocurre fallar
    tracker.on('error', function (error) {
        console.warn('Error con el GPS: ', error.message)
    });
}

