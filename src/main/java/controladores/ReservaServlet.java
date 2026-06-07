package controladores;

import DAO.PlazaDAO;
import config.Conexion;
import modelos.Plaza;
import modelos.Usuario;
import org.bson.Document;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ReservaServlet")
public class ReservaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Obtenemos al usuario para saber de quién es la reserva
        HttpSession session = request.getSession();
        Usuario usuarioActual = (Usuario) session.getAttribute("usuarioLogueado");

        if (usuarioActual == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String plazaId = request.getParameter("plaza");
        String cajon = request.getParameter("cajon");
        String matricula = request.getParameter("matricula");
        int horas = Integer.parseInt(request.getParameter("horas"));

        // Buscamos la plaza para sacar su precio
        PlazaDAO dao = new PlazaDAO();
        Plaza plaza = dao.obtenerPorId(plazaId);

        // Extraemos el precio y calculamos
        java.util.regex.Matcher matcher = java.util.regex.Pattern.compile("[0-9]+").matcher(plaza.getPrecio());        int precioHora = 0;
        if (matcher.find()) {
            precioHora = Integer.parseInt(matcher.group());
        }
        int precioTotal = horas * precioHora;

        // Guardamos en la memoria ram para que se ponga negro el cajon en el mapa
        ServletContext contexto = getServletContext();
        List<String> ocupados = (List<String>) contexto.getAttribute("cajonesOcupados");
        if (ocupados == null) ocupados = new ArrayList<>();
        if (!ocupados.contains(cajon)) ocupados.add(cajon);
        contexto.setAttribute("cajonesOcupados", ocupados);

        Document nuevaReserva = new Document()
                .append("correo_usuario", usuarioActual.getEmail()) // Para saber de quién es
                .append("plaza_nombre", plaza.getNombre())
                .append("cajon", cajon)
                .append("matricula", matricula)
                .append("horas", horas)
                .append("total", precioTotal)
                .append("estado", "ACTIVA") // ACTIVA o FINALIZADA
                .append("fecha_reserva", new Date());

        // Insertamos en la colección "Reservas"
        Conexion.getDatabase().getCollection("Reservas").insertOne(nuevaReserva);

        String idGenerado = nuevaReserva.getObjectId("_id").toHexString();

        // 5. Mandamos los datos limpios al Ticket
        request.setAttribute("idReserva", idGenerado);
        request.setAttribute("plaza", plaza.getNombre());
        request.setAttribute("cajon", cajon);
        request.setAttribute("matricula", matricula);
        request.setAttribute("horas", horas);
        request.setAttribute("precio",precioTotal);

        request.getRequestDispatcher("ticket.jsp").forward(request, response);
    }
}