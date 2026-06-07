package DAO;

import config.Conexion;
import modelos.Usuario;
import modelos.Vehiculos;
import modelos.TipoVehiculo;
import com.mongodb.client.MongoCollection;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Filters.and;
import org.bson.Document;
import org.bson.types.ObjectId;
import com.mongodb.client.model.Updates;

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

            Document vDoc = new Document("idvehiculo", v.getIdvehiculo())
                    .append("placa", v.getPlaca())
                    .append("marca", v.getMarca())
                    .append("modelo", v.getModelo())
                    .append("color", v.getColor())
                    .append("tipo", v.getTipo().name()) // Guardamos el Enum como String
                    .append("activo", v.isActivo());
            vehiculosDocs.add(vDoc);
        }

        // Creamos el documento BSON para insertar en Mongo
        Document doc = new Document("nombre", user.getNombre())
                .append("email", user.getEmail())
                .append("password", user.getPassword())
                .append("telefono", user.getTelefono())
                .append("es_discapacitado", false)
                .append("es_vip", false)
                .append("saldo_deudor", 0.0)
                .append("vehiculos", vehiculosDocs); // Arreglo vacío para autos

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
                    Vehiculos vehiculo = new Vehiculos();
                    vehiculo.setIdvehiculo(vDoc.getString("idvehiculo"));
                    vehiculo.setPlaca(vDoc.getString("placa"));
                    vehiculo.setMarca(vDoc.getString("marca"));
                    vehiculo.setModelo(vDoc.getString("modelo"));
                    vehiculo.setColor(vDoc.getString("color"));

                    // Enum y el estado Activo
                    String tipo = vDoc.getString("tipo");
                    if(tipo != null) vehiculo.setTipo(TipoVehiculo.valueOf(tipo));

                    vehiculo.setActivo(vDoc.getBoolean("activo", false));

                    vehiculosJava.add(vehiculo);
                }
            }

            Usuario usuarioEncontrado = new Usuario(
                    doc.getString("nombre"),
                    doc.getString("email"),
                    doc.getString("password"),
                    doc.getString("telefono"),
                    doc.getBoolean("es_discapacitado"),
                    doc.getDouble("saldo_deudor"),
                    vehiculosJava
            );
            usuarioEncontrado.setId(doc.getObjectId("_id").toString());
            usuarioEncontrado.setEsVip(doc.getBoolean("es_vip", false));
            return usuarioEncontrado;
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

    public boolean agregarVehiculo(String correoUsuario, Vehiculos nuevoVehiculo) {
        try {
            org.bson.Document vehiculoDoc = new org.bson.Document()
                    .append("idvehiculo", nuevoVehiculo.getIdvehiculo())
                    .append("placa", nuevoVehiculo.getPlaca())
                    .append("marca", nuevoVehiculo.getMarca())
                    .append("modelo", nuevoVehiculo.getModelo())
                    .append("color", nuevoVehiculo.getColor())
                    .append("tipo", nuevoVehiculo.getTipo().name())
                    .append("activo", nuevoVehiculo.isActivo());

            // Lo inyectamos en la lista de vehículos del usuario buscando por su email
            coleccionUsuarios.updateOne(
                    com.mongodb.client.model.Filters.eq("email", correoUsuario), // Ajusta "correo" al nombre exacto de tu campo en la DB si es diferente
                    com.mongodb.client.model.Updates.push("vehiculos", vehiculoDoc)
            );
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean seleccionarVehiculoActivo(String idUsuario, String idVehiculoActivo) {
        try {
            ObjectId uId = new ObjectId(idUsuario);

            // Ponemos TODOS los vehículos de este usuario en activo = false
            coleccionUsuarios.updateOne(
                    eq("_id", uId),
                    Updates.set("vehiculos.$[].activo", false)
            );

            // Ponemos SOLO el que queremos usar que este activo
            coleccionUsuarios.updateOne(
                    and(eq("_id", uId), eq("vehiculos.idvehiculo", idVehiculoActivo)),
                    Updates.set("vehiculos.$.activo", true)
            );
            return true;
        } catch (Exception e) {
            System.err.println("Error al seleccionar vehículo: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizarPerfil(String idUsuario, String nuevoNombre, String nuevoTelefono, boolean esDiscapacitado, boolean esVip) {
        try {
            coleccionUsuarios.updateOne(
                    eq("_id", new ObjectId(idUsuario)),
                    Updates.combine(
                            Updates.set("nombre", nuevoNombre),
                            Updates.set("telefono", nuevoTelefono),
                            Updates.set("es_discapacitado", esDiscapacitado),
                            Updates.set("es_vip", esVip)
                    )
            );
            return true;
        } catch (Exception e) {
            System.err.println("Error al actualizar perfil: " + e.getMessage());
            return false;
        }
    }


}
