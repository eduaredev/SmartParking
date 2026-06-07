package controladores;

import config.Conexion;
import org.bson.Document;
import org.bson.types.ObjectId;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/LiberarServlet")
public class LiberarServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String cajonALiberar = request.getParameter("cajon");
        String idReserva = request.getParameter("id");

        if (cajonALiberar != null) {
            ServletContext contexto = getServletContext();
            List<String> ocupados = (List<String>) contexto.getAttribute("cajonesOcupados");

            if (ocupados != null) {
                // Lo removemos de la lista de ocupados
                ocupados.remove(cajonALiberar);
                contexto.setAttribute("cajonesOcupados", ocupados);
            }
        }

        if (idReserva != null && !idReserva.isEmpty()) {
            MongoCollection<Document> coleccion = Conexion.getDatabase().getCollection("Reservas");

            // Buscamos el documento por su id y cambiamos el estado a "FINALIZADA"
            coleccion.updateOne(
                    Filters.eq("_id", new ObjectId(idReserva)),
                    Updates.set("estado", "FINALIZADA")
            );
        }

        // Redirigimos al mapa principal
        response.sendRedirect("dashboard.jsp");
    }
}