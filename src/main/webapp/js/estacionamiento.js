document.addEventListener('DOMContentLoaded', () => {

    // Mostrar el panel correcto según la variable global
    if (window.USUARIO_ES_VIP) {
        document.getElementById('panel-vip').style.display = 'block';
    } else {
        document.getElementById('panel-estandar').style.display = 'block';
    }

    const mapaObjeto = document.getElementById('mapa-svg');
    if (mapaObjeto) {
        mapaObjeto.addEventListener('load', function() {
            const svgDoc = mapaObjeto.contentDocument;
            if (!svgDoc) return;

            // Ocultar la ruta base gris de A*
            const rutaGris = svgDoc.querySelector('[id*="graforutas" i]');
            if (rutaGris) rutaGris.style.display = 'none';

            const todosLosElementos = svgDoc.querySelectorAll('[id*="-"]');
            const coloresPorSufijo = {
                "C": "#b0bec5", // Gris
                "T": "#e74c3c", // Rojo
                "M": "#2ecc71", // Verde
                "D": "#3498db", // Azul
                "V": "#f1c40f"  // Dorado
            };

            todosLosElementos.forEach(cajon => {
                const idCompleto = cajon.id;
                const partes = idCompleto.split('-');
                const nombreVisual = partes[0];
                const sufijo = partes[partes.length - 1].toUpperCase();

                if (coloresPorSufijo[sufijo]) {

                    let estaOcupado = window.CAJONES_OCUPADOS.includes(idCompleto);

                    // Si está ocupado, forzamos color negro y cambiamos el texto
                    cajon.style.fill = estaOcupado ? "#000000" : coloresPorSufijo[sufijo];
                    cajon.style.cursor = estaOcupado ? 'not-allowed' : 'pointer';

                    let coordX = 0;
                    let coordY = 0;

                    try {
                        const medidas = cajon.getBBox();
                        coordX = medidas.x + (medidas.width / 2);
                        coordY = medidas.y + (medidas.height / 2);

                        // Traemos el nombre de los ID que le puse en figma y los voy poniendo en cada recuadro
                        const textoSVG = svgDoc.createElementNS('http://www.w3.org/2000/svg', 'text');
                        textoSVG.setAttribute('x', coordX);
                        textoSVG.setAttribute('y', coordY);
                        textoSVG.setAttribute('text-anchor', 'middle');
                        textoSVG.setAttribute('dominant-baseline', 'central');
                        textoSVG.setAttribute('fill', '#ffffff'); // Color blanco
                        textoSVG.setAttribute('font-size', '8px'); // Tamaño
                        textoSVG.setAttribute('font-weight', 'bold');
                        textoSVG.setAttribute('font-family', 'Inter, sans-serif');
                        textoSVG.style.pointerEvents = 'none';

                        // Si está ocupado pone una X, si está libre pone su nombre normal (Ej. B4)
                        textoSVG.textContent = estaOcupado ? "X" : nombreVisual;

                        cajon.parentNode.appendChild(textoSVG);
                    } catch (e) { console.warn("No se pudo centrar el texto", e); }

                    // EVENTO DE CLIC
                    cajon.addEventListener('click', () => {
                        if (estaOcupado) {
                            alert("Este cajón ya está ocupado por otro usuario.");
                            return;
                        }

                        if (window.TIPO_VEHICULO === "NINGUNO") {
                            alert("Debes seleccionar un vehículo activo en tu perfil antes de reservar.");
                            window.location.href = "vehiculo.jsp";
                            return;
                        }

                        if (!window.USUARIO_ES_VIP) {
                            alert("Como usuario Estándar debes usar el menú izquierdo para indicar a qué tienda vas.");
                            return;
                        }

                        if (sufijo === "D" && !window.USUARIO_ES_DISCAPACITADO) {
                            alert("Este es un cajón exclusivo para personas con discapacidad.");
                            return;
                        }

                        console.log(`Usuario VIP solicitando cajón: ${idCompleto} en coordenadas: ${coordX}, ${coordY}`);
                        pedirRutaAlBackend(idCompleto, coordX, coordY);
                    });
                }
            });
        });
    }
});


// Al moverlo a un archivo externo, exponemos la función a 'window' para que el HTML pueda verla
window.solicitarRutaEstandar = function() {
    if (window.TIPO_VEHICULO === "NINGUNO") {
        alert("Debes seleccionar un vehículo activo en tu perfil antes de reservar.");
        window.location.href = "vehiculo.jsp"; // Corregido: Ahora lleva a la pestaña correcta
        return;
    }

    const select = document.getElementById('select-tienda');
    const coords = select.value.split(',');
    pedirRutaAlBackend("", coords[0], coords[1]);
};

function pedirRutaAlBackend(cajonVipDeseado, destinoX, destinoY) {
    const datos = new URLSearchParams();
    datos.append("origen_x", window.ORIGEN_X);
    datos.append("origen_y", window.ORIGEN_Y);
    datos.append("destino_x", destinoX);
    datos.append("destino_y", destinoY);
    datos.append("es_discapacitado", window.USUARIO_ES_DISCAPACITADO);
    datos.append("tipo_vehiculo", window.TIPO_VEHICULO);
    datos.append("es_vip", window.USUARIO_ES_VIP);
    datos.append("cajon_deseado", cajonVipDeseado);

    console.log("Consultando al Motor A* de Python a través de Java...");

    fetch("AsignacionServlet", {
        method: "POST",
        body: datos,
        headers: { "Content-Type": "application/x-www-form-urlencoded" }
    })
        .then(res => res.json())
        .then(data => {
            if(data.status === "error") {
                alert("Hubo un problema: " + data.mensaje);
            } else {
                // CORRECCIÓN: La asignación del input va aquí, en la respuesta correcta del servidor
                dibujarRutaEnSVG(data.ruta);

                const inputCajon = document.getElementById('cajon-seleccionado');
                if (inputCajon) {
                    inputCajon.value = data.cajon_asignado;
                }
            }
        })
        .catch(err => console.error("Error en la petición:", err));
}

function dibujarRutaEnSVG(arregloRuta) {
    const svgDoc = document.getElementById('mapa-svg').contentDocument;
    if(!svgDoc) return;

    // Borramos la ruta anterior
    const rutaVieja = svgDoc.getElementById('ruta-generada');
    if(rutaVieja) rutaVieja.remove();

    // Convertir [[x1, y1], [x2, y2]] a "x1,y1 x2,y2"
    const puntosString = arregloRuta.map(punto => `${punto[0]},${punto[1]}`).join(' ');

    const polyline = svgDoc.createElementNS('http://www.w3.org/2000/svg', 'polyline');
    polyline.setAttribute('points', puntosString);
    polyline.setAttribute('fill', 'none');
    polyline.setAttribute('stroke', '#e74c3c'); // Color de la ruta
    polyline.setAttribute('stroke-width', '5'); // Grosor
    polyline.setAttribute('stroke-linejoin', 'round');
    polyline.setAttribute('id', 'ruta-generada');

    svgDoc.documentElement.appendChild(polyline);
}

window.validarReserva = function() {
    const inputCajon = document.getElementById('cajon-seleccionado').value;

    // Si el input está vacío o sigue diciendo el mensaje por defecto
    if (!inputCajon || inputCajon.trim() === "") {
        alert("Debes seleccionar un cajón en el mapa antes de confirmar tu reserva");
        return false;
    }
    return true; // Si hay cajón, deja pasar la reserva
};