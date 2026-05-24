import * as mapa from './mapa.js'
import * as marcadores from './marcadores.js'

const coordsplaza1 = [-96.10259651328514, 19.139171912301613];

const plaza1 = marcadores.crearMarcador(coordsplaza1[0], coordsplaza1[1], 'blue')
const pinusuario = marcadores.crear_pinusuario();

mapa.marcadores.addFeature(plaza1);
mapa.marcadores.addFeature(pinusuario);

marcadores.tracker(pinusuario, mapa.map, mapa.ruta, coordsplaza1);


