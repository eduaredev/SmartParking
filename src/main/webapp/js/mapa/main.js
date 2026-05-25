import * as mapa from './mapa.js'
import * as marcadores from './marcadores.js'
import * as evento from './evento.js'

// const coordsplaza1 = [-96.10259651328514, 19.139171912301613];
//const plaza1 = marcadores.crearMarcador(coordsplaza1[0], coordsplaza1[1], 'blue', infoAndamar)
const pinusuario = marcadores.crear_pinusuario();

mapa.marcadores.addFeature(pinusuario);

marcadores.tracker(pinusuario, mapa.map, mapa.ruta);

evento.inicializarEventos(mapa,pinusuario);

fetch('PlazaServlet')
    .then(respuesta => respuesta.json())
    .then(plazasDesdeMongo => {

        // Iteramos sobre la lista que nos devolvió Java
        plazasDesdeMongo.forEach(plaza => {

            // Mapeamos los campos del JSON de Mongo a las propiedades que requiere tu tarjeta
            const datosMarcador = {
                id: plaza.id_plaza,
                esPlaza: true,
                nombre: plaza.nombre,
                direccion: plaza.direccion,
                precio: plaza.precio,
                flujo: plaza.flujo
            };

            // Creamos el marcador azul con las coordenadas de la base de datos
            // Recuerda que en Mongo lo guardamos como un arreglo [longitud, latitud]
            const marcador = marcadores.crearMarcador(
                plaza.coordenadas[0],
                plaza.coordenadas[1],
                'blue',
                datosMarcador
            );

            // Lo pintamos en el mapa
            mapa.marcadores.addFeature(marcador);
        });
    })
    .catch(error => {
        console.error("Error al conectar con PlazasServlet o leer la base de datos:", error);
    });


