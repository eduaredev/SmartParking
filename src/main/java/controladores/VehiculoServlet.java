package controladores;

import DAO.UsuarioDAO;
import modelos.TipoVehiculo;
import modelos.Usuario;
import modelos.Vehiculos;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/VehiculoServlet")
public class VehiculoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Usuario usuarioActual = (Usuario) session.getAttribute("usuarioLogueado");

        if (usuarioActual == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        UsuarioDAO dao = new UsuarioDAO();

        // 1. AGREGAR NUEVO VEHÍCULO
        if ("agregar".equals(accion)) {
            String placa = request.getParameter("placa").toUpperCase();
            String marca = request.getParameter("marca");
            String modelo = request.getParameter("modelo");
            String color = request.getParameter("color");
            String tipoStr = request.getParameter("tipo"); // COCHE, CAMIONETA o MOTO

            // Creamos el objeto vehículo. Si es el primer coche que registra, lo hacemos "activo" por defecto.
            boolean esElPrimero = usuarioActual.getVehiculos() == null || usuarioActual.getVehiculos().isEmpty();
            Vehiculos nuevoVehiculo = new Vehiculos(usuarioActual.getId(), placa, marca, modelo, color, TipoVehiculo.valueOf(tipoStr), esElPrimero);

            if (dao.agregarVehiculo(usuarioActual.getId(), nuevoVehiculo)) {
                usuarioActual.getVehiculos().add(nuevoVehiculo); // Lo agregamos a la sesión actual
                session.setAttribute("usuarioLogueado", usuarioActual); // Actualizamos la sesión
            }

            // Recargamos la página
            response.sendRedirect("vehiculo.jsp");

            // 2. CAMBIAR VEHÍCULO ACTIVO
        } else if ("seleccionar".equals(accion)) {
            String idVehiculo = request.getParameter("idVehiculo");

            if (dao.seleccionarVehiculoActivo(usuarioActual.getId(), idVehiculo)) {
                // Actualizamos la sesión de Java para que refleje el cambio inmediatamente
                for (Vehiculos v : usuarioActual.getVehiculos()) {
                    v.setActivo(v.getIdvehiculo().equals(idVehiculo));
                }
                session.setAttribute("usuarioLogueado", usuarioActual);

                // Le respondemos a JavaScript que todo salió bien
                response.setContentType("application/json");
                response.getWriter().write("{\"status\":\"success\"}");
            } else {
                response.setContentType("application/json");
                response.getWriter().write("{\"status\":\"error\"}");
            }
        }
    }
}