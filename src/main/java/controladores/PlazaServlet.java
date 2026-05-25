package controladores;

import config.Conexion;
import com.mongodb.client.MongoCollection;
import org.bson.Document;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/PlazaServlet")
public class PlazaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Configuramos la respuesta como JSON y con codificación UTF-8 para acentos
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        try {
            // Extraemos desde MongoDB
            MongoCollection<Document> coleccionPlazas = Conexion.getDatabase().getCollection("Plazas");
            List<Document> plazasDocs = coleccionPlazas.find().into(new ArrayList<>());

            // Construimos un arreglo JSON de forma manual uniendo los documentos de Mongo
            StringBuilder jsonArray = new StringBuilder("[");
            for (int i = 0; i < plazasDocs.size(); i++) {
                jsonArray.append(plazasDocs.get(i).toJson());
                if (i < plazasDocs.size() - 1) {
                    jsonArray.append(",");
                }
            }
            jsonArray.append("]");

            // Enviamos el JSON al frontend
            out.print(jsonArray.toString());
            out.flush();

        } catch (Exception e) {
            System.err.println("Error al obtener las plazas de MongoDB: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"No se pudieron cargar los estacionamientos\"}");
        }
    }
}