package DAO;

import config.Conexion;
import org.bson.Document;
import org.bson.types.ObjectId;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;

import java.util.ArrayList;
import java.util.List;

public class ReservaDAO {
    private MongoCollection<Document> coleccionReservas;

    public ReservaDAO() {
        this.coleccionReservas = Conexion.getDatabase().getCollection("Reservas");
    }

    // Metodo para crear la reserva y devolver el ID generado
    public String crearReserva(Document nuevaReserva) {
        ObjectId nuevoId = new ObjectId();
        nuevaReserva.append("_id", nuevoId);
        coleccionReservas.insertOne(nuevaReserva);
        return nuevoId.toHexString();
    }

    // Metodo para obtener el historial de un usuario específico
    public List<Document> obtenerHistorialPorCorreo(String correoUsuario) {
        List<Document> misReservas = new ArrayList<>();
        // Busca y ordena de la más reciente a la más antigua (-1)
        try (MongoCursor<Document> cursor = coleccionReservas.find(Filters.eq("correo_usuario", correoUsuario))
                .sort(new Document("fecha_reserva", -1)).iterator()) {
            while (cursor.hasNext()) {
                misReservas.add(cursor.next());
            }
        }
        return misReservas;
    }

    // Metodo para cambiar el estado a FINALIZADA
    public void finalizarReserva(String idReserva) {
        coleccionReservas.updateOne(
                Filters.eq("_id", new ObjectId(idReserva)),
                Updates.set("estado", "FINALIZADA")
        );
    }
}