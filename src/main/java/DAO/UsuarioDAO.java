package DAO;

import config.Conexion;
import modelos.Usuario;
import modelos.Vehiculos;
import modelos.TipoVehiculo;
import com.mongodb.client.MongoCollection;
import static com.mongodb.client.model.Filters.eq;
import org.bson.Document;

import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {
    private MongoCollection<Document> coleccionUsuarios;

    public UsuarioDAO() {
        this.coleccionUsuarios = Conexion.getDatabase().getCollection("Users");
    }
    public boolean registrarUsuario(Usuario user) {
        // Verificacion para ver si ya eciste el usuario mediante el filtro por email
        if (coleccionUsuarios.find(eq("email", user.getEmail())).first() != null) {
            return false; // Si encuentra el mismo email retorna falso
        }

        List<Document> vehiculosDocs = new ArrayList<>();
        for (int i = 0; i < user.getVehiculos().size(); i++) {

            Vehiculos v = user.getVehiculos().get(i);

            Document vDoc = new Document("placa", v.getPlaca())
                    .append("marca", v.getMarca())
                    .append("modelo", v.getModelo())
                    .append("color", v.getColor())
                    .append("tipo", v.getTipo().name()); // Guardamos el Enum como String
            vehiculosDocs.add(vDoc);
        }

        // Creamos el documento BSON para insertar en Mongo
        Document doc = new Document("nombre", user.getNombre())
                .append("email", user.getEmail())
                .append("password", user.getPassword())
                .append("telefono", user.getTelefono())
                .append("es_discapacitado", false)
                .append("saldo_deudor", 0.0)
                .append("vehiculos", new ArrayList<>()); // Arreglo vacío para autos

        // Insertamos en la coleccion
        coleccionUsuarios.insertOne(doc);
        return true;
    }

    public Usuario buscarPorEmail(String email) {
        Document doc = coleccionUsuarios.find(eq("email", email)).first();

        if (doc != null) {
            List<Document> vehiculosDocs = doc.getList("vehiculos", Document.class);
            List<Vehiculos> vehiculosJava = new ArrayList<>();

            if (vehiculosDocs != null) {
                for (Document vDoc : vehiculosDocs) {
                    Vehiculos vehiculo = new Vehiculos(
                            vDoc.getString("placa"),
                            vDoc.getString("marca"),
                            vDoc.getString("modelo"),
                            vDoc.getString("color"),
                            TipoVehiculo.valueOf(vDoc.getString("tipo"))
                    );
                    vehiculosJava.add(vehiculo);
                }
            }

            return new Usuario(
                    doc.getString("nombre"),
                    doc.getString("email"),
                    doc.getString("password"),
                    doc.getString("telefono"),
                    doc.getBoolean("es_discapacitado"),
                    doc.getDouble("saldo_deudor"),
                    vehiculosJava
            );
        }
        return null; // No existe en MongoDB
    }

    public Usuario validarLogin(String email, String password) {
        Usuario usuario = buscarPorEmail(email);

        //Esto es un candado para evitar que accedan con la contraseña que preestablecí para cuentas desde google
        if (usuario.getPassword().equals("GOOGLE_AUTH")) {
            System.out.println("Intento de acceso manual a cuenta de Google bloqueado: " + email);
            return null;
        }

        if (usuario != null && usuario.getPassword().equals(password)) {
            return usuario;
        }
        return null;
    }
}
