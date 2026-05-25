import * as osrm from './osrm.js';
import * as mapajs from './mapa.js';

export function inicializarEventos(mapa, pinusuario) {
    // Elementos del HTML para la tarjeta
    const contenedorPopup = document.getElementById('tarjeta');
    const contenidoPopup = document.getElementById('tarjeta_contenido');
    const btnCerrar = document.getElementById('tarjeta_cerrar');

    // Crear el Overlay y añadirlo al mapa
    const overlay = new ol.Overlay({
        element: contenedorPopup,
        autoPan: true,
        autoPanAnimation: { duration: 250 }
    });
    mapa.map.addOverlay(overlay);

    // Lógica para cerrar la tarjeta
    btnCerrar.onclick = function () {
        contenedorPopup.style.display = 'none';
        overlay.setPosition(undefined);
        mapajs.setDestino(null); //Borramos la ruta al cerrar la tarjeta
        mapa.ruta.clear();
        return false; // Evita que la página salte hacia arriba
    };

    // Lógica de clics en el mapa
    mapa.map.on('singleclick', function (evt) {
        const feature = mapa.map.forEachFeatureAtPixel(evt.pixel, function (feature) {
            return feature;
        });

        // Si tocamos algo y ese algo tiene la propiedad 'esPlaza'
        if (feature && feature.get('esPlaza')) {
            const idPlaza = feature.get('id');
            const nombre = feature.get('nombre');
            const direccion = feature.get('direccion');
            const precio = feature.get('precio');
            const flujo = feature.get('flujo');
            const coordenadas = feature.getGeometry().getCoordinates();

            // Armamos el HTML de la tarjeta
            // Los emojis los saqué de esta pagina https://emojikeyboard.top/es/
            contenidoPopup.innerHTML = `
                <h3>${nombre}</h3>
                <p>📍 <strong>Ubicación:</strong> ${direccion}</p>
                <p>🎟️ <strong>Boleto:</strong> ${precio}</p>
                <p>⏱️ <strong>Tiempo Promedio Reserva:</strong> ${flujo}</p>
                <p>📏 <strong>Distancia:</strong> <span id="distancia-llegada" class="dato-resaltado">...</span></p>
                <p>🚗 <strong>Llegarás en:</strong> <span id="tiempo-llegada" class="dato-resaltado">Calculando...</span></p>
                <a href="estacionamiento.jsp?plaza=${idPlaza}" class="boton_accion">Seleccionar Estacionamiento</a>
            `;

            contenedorPopup.style.display = 'block';
            overlay.setPosition(coordenadas);

            // Recalculamos la ruta hacia esta nueva plaza
            const destinonuevo = ol.proj.toLonLat(coordenadas)
            mapajs.setDestino(destinonuevo);

            const coordsActuales = pinusuario.getGeometry().getCoordinates();

            if(coordsActuales) {
                osrm.osrm(ol.proj.toLonLat(coordsActuales), destinonuevo, mapa.ruta, mapa.map);
            }
        } else {
            // Si tocamos en cualquier otro lado, cerramos
            contenedorPopup.style.display = 'none';
            overlay.setPosition(undefined);
        }
    });
}