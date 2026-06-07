package controladores;

import config.Conexion;
import modelos.Usuario;
import org.bson.Document;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.model.Filters;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/HistorialServlet")
public class HistorialServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuario usuarioActual = (Usuario) session.getAttribute("usuarioLogueado");

        if (usuarioActual == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Document> misReservas = new ArrayList<>();
        MongoCollection<Document> coleccion = Conexion.getDatabase().getCollection("Reservas");

        // Buscamos las reservas del usuario y las ordenamos de la más reciente a la más antigua
        try (MongoCursor<Document> cursor = coleccion.find(Filters.eq("correo_usuario", usuarioActual.getEmail()))
                .sort(new Document("fecha_reserva", -1)).iterator()) {
            while (cursor.hasNext()) {
                misReservas.add(cursor.next());
            }
        }

        // Enviamos la lista al JSP
        request.setAttribute("misReservas", misReservas);
        request.getRequestDispatcher("historial.jsp").forward(request, response);
    }
}