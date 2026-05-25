package DAO;

import config.Conexion;
import modelos.Plaza;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import org.bson.Document;

import java.util.ArrayList;
import java.util.List;

public class PlazaDAO {
    private MongoCollection<Document> coleccionPlazas;

    public PlazaDAO() {
        // Conectamos a la coleccion de MongoDB
        this.coleccionPlazas = Conexion.getDatabase().getCollection("Plazas");
    }

    // Metodo para obtener todas las plazas para dibujar el mapa
    public List<Plaza> obtenerTodas() {
        List<Plaza> listaPlazas = new ArrayList<>();

        try (MongoCursor<Document> cursor = coleccionPlazas.find().iterator()) {
            while (cursor.hasNext()) {
                Document doc = cursor.next();

                Plaza plaza = new Plaza(
                        doc.getString("id_plaza"),
                        doc.getString("nombre"),
                        doc.getString("direccion"),
                        (List<Double>) doc.get("coordenadas"),
                        doc.getString("precio"),
                        doc.getString("flujo")
                );

                listaPlazas.add(plaza);
            }
        }
        return listaPlazas;
    }
}