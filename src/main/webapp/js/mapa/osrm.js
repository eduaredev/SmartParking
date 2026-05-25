

export function osrm(origen, destino, ruta, mapa) {
    const url = `https://router.project-osrm.org/route/v1/driving/${origen[0]},${origen[1]};${destino[0]},${destino[1]}?overview=full&geometries=geojson&alternatives=true`;

    fetch(url).then(respuesta => respuesta.json()).then(datos => {
        if (datos.routes && datos.routes.length > 0) {
            // const rutajson = datos.routes[0].geometry;

            ruta.clear();

            const formato = new ol.format.GeoJSON();

            const rutas_alternas = datos.routes.slice(0, 2);

            rutas_alternas.forEach((rutaOSRM, index) => {
                const rutajson = rutaOSRM.geometry;

                const featureruta = formato.readFeature({
                    type: 'Feature',
                    geometry: rutajson,
                }, {
                    dataProjection: 'EPSG:4326', //Formato Satelital que manda OSRM
                    featureProjection: mapa.getView().getProjection()
                });

                if (index === 1) {
                    featureruta.setStyle(new ol.style.Style({
                        stroke: new ol.style.Stroke({
                            color: 'gray',
                            width: 4,
                            lineDash: [10, 10]
                        })
                    }));
                }

                ruta.addFeature(featureruta);
            });

            const minutoscrudos = Math.round(datos.routes[0].duration / 60);
            const minutosrestantes = Math.round(minutoscrudos * 1.3);
            const distanciaMetros = datos.routes[0].distance;
            const distanciaKm = (distanciaMetros / 1000).toFixed(2); // .toFixed(2) deja dos decimales

            const etiquetaTiempo = document.getElementById('tiempo-llegada');
            const etiquetaDistancia = document.getElementById('distancia-llegada');

            if (etiquetaTiempo) etiquetaTiempo.innerText = minutosrestantes + " min";
            if (etiquetaDistancia) etiquetaDistancia.innerText = distanciaKm + " km";

        }
    })
        .catch(error => console.error("Error con OSRM:", error))
}