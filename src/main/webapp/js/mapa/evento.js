import * as osrm from './osrm.js';
import * as mapajs from './mapa.js';

// La misma funcion de antes pero la pasamos a los botones del panel izquierdo
export function mostrarplaza(datos, coordenadas, mapa, pinusuario){
    const panelInfo = document.getElementById('info-plaza-lateral');
    const menuPrincipal = document.getElementById('menu-principal');

    // Armamos el HTML de la tarjeta
    // Los emojis los saqué de esta pagina https://emojikeyboard.top/es/
    // Por practicidad y para evitar parsear datos de js a html, fueron de html a datos de js con la funcion innetHTML
    // Puedo escribir codigo HTML con etiquetas y referenciar botones con la información de mi mapa y distancias
    panelInfo.innerHTML = `
        <h3>${datos.nombre}</h3>
        <p>📍 <strong>Ubicación:</strong> ${datos.direccion}</p>
        <p>🎟️ <strong>Boleto:</strong> ${datos.precio}</p>
        <p>⏱️ <strong>Tiempo Promedio Reserva:</strong> ${datos.flujo}</p>
        <p>📏 <strong>Distancia:</strong> <span id="distancia-llegada" class="dato-resaltado">...</span></p>
        <p>🚗 <strong>Llegarás en:</strong> <span id="tiempo-llegada" class="dato-resaltado">Calculando...</span></p>
        <a href="EstacionamientoServlet?plaza=${datos.id}" class="btn btn-primary-tarjeta">Seleccionar Estacionamiento</a>
        <button id="btn-cerrar-info" class="btn btn-primary-tarjeta w-100 fw-bold py-2">Cancelar / Cerrar</button>
    `;

    menuPrincipal.style.display = 'none';
    panelInfo.style.display = 'block';

    document.getElementById('btn-cerrar-info').onclick = function () {
        panelInfo.style.display = 'none';
        menuPrincipal.style.display = 'flex'; // Volvemos a mostrar el menú
        mapajs.setDestino(null);
        mapa.ruta.clear();
    };

    // Recalculamos la ruta hacia esta nueva plaza
    const destinoNuevo = ol.proj.toLonLat(coordenadas);
    mapajs.setDestino(destinoNuevo);

    const coordsActuales = pinusuario.getGeometry().getCoordinates();
    if(coordsActuales) {
        osrm.osrm(ol.proj.toLonLat(coordsActuales), destinoNuevo, mapa.ruta, mapa.map);
    }

}

export function inicializarEventos(mapa, pinusuario) {
    // Lógica de clics en el mapa
    const panelInfo = document.getElementById('info-plaza-lateral');
    const menuPrincipal = document.getElementById('menu-principal');

    mapa.map.on('singleclick', function (evt) {

        // Si tocamos en cualquier otro lado, cerramos
        if(panelInfo.style.display === 'block') {
            panelInfo.style.display = 'none';
            menuPrincipal.style.display = 'flex';
            mapajs.setDestino(null);
            mapa.ruta.clear();
        }
    });
}