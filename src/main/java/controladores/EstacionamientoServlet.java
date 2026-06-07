package controladores;

import modelos.Usuario;
import modelos.Vehiculos;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/EstacionamientoServlet")
public class EstacionamientoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuario usuarioActual = (Usuario) session.getAttribute("usuarioLogueado");

        if (usuarioActual == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        boolean esVip = usuarioActual.isEsVip();
        boolean esDiscapacitado = usuarioActual.isEsDiscapacitado();

        String tipoVehiculoActivo = "NINGUNO";
        String placaActiva = "SIN PLACA"; // Extraemos la placa
        if (usuarioActual.getVehiculos() != null) {
            for (Vehiculos v : usuarioActual.getVehiculos()) {
                if (v.isActivo()) {
                    tipoVehiculoActivo = v.getTipo().name();
                    placaActiva = v.getPlaca();
                    break;
                }
            }
        }

        ServletContext contexto = getServletContext();
        List<String> ocupados = (List<String>) contexto.getAttribute("cajonesOcupados");
        if (ocupados == null) ocupados = new ArrayList<>();

        // Convertimos la lista a un arreglo de JavaScript
        StringBuilder arrayJs = new StringBuilder("[");
        for (int i = 0; i < ocupados.size(); i++) {
            arrayJs.append("'").append(ocupados.get(i)).append("'");
            if (i < ocupados.size() - 1) arrayJs.append(",");
        }
        arrayJs.append("]");

        request.setAttribute("cajonesOcupadosJs", arrayJs.toString());
        request.setAttribute("placaVehiculo", placaActiva);
        request.setAttribute("esVip", esVip);
        request.setAttribute("esDiscapacitado", esDiscapacitado);
        request.setAttribute("tipoVehiculo", tipoVehiculoActivo);

        // Redirigimos al panel de estacionamiento pero ya con los datos capturados
        request.getRequestDispatcher("estacionamiento.jsp").forward(request, response);
    }
}