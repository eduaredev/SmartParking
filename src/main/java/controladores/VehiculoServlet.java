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

        if ("agregar".equals(accion)) {
            String placa = request.getParameter("placa").toUpperCase();
            String marca = request.getParameter("marca");
            String modelo = request.getParameter("modelo");
            String color = request.getParameter("color");
            String tipoStr = request.getParameter("tipo"); // COCHE, CAMIONETA o MOTO

            // Generamos un id unico para cada vehiculo
            String idVehiculoPropio = new org.bson.types.ObjectId().toHexString();

            boolean esElPrimero = usuarioActual.getVehiculos() == null || usuarioActual.getVehiculos().isEmpty();

            // Usamos el nuevo ID propio, NO el del usuario
            Vehiculos nuevoVehiculo = new Vehiculos(idVehiculoPropio, placa, marca, modelo, color, TipoVehiculo.valueOf(tipoStr), esElPrimero);

            // Usamos el email para buscar al dueño en la base de datos
            if (dao.agregarVehiculo(usuarioActual.getEmail(), nuevoVehiculo)) {

                if (usuarioActual.getVehiculos() == null) {
                    usuarioActual.setVehiculos(new java.util.ArrayList<>());
                }
                usuarioActual.getVehiculos().add(nuevoVehiculo); // Lo agregamos a la sesión
                session.setAttribute("usuarioLogueado", usuarioActual); // Actualizamos la sesión
            }

            // Recargamos la página
            response.sendRedirect("vehiculo.jsp");

        } else if ("seleccionar".equals(accion)) {
            String idVehiculo = request.getParameter("idVehiculo");

            if (dao.seleccionarVehiculoActivo(usuarioActual.getId(), idVehiculo)) {
                // Actualizamos la sesión de Java para que refleje el cambio inmediatamente
                for (Vehiculos v : usuarioActual.getVehiculos()) {
                    v.setActivo(v.getIdvehiculo().equals(idVehiculo));
                }
                session.setAttribute("usuarioLogueado", usuarioActual);

                response.setContentType("application/json");
                response.getWriter().write("{\"status\":\"success\"}");
            } else {
                response.setContentType("application/json");
                response.getWriter().write("{\"status\":\"error\"}");
            }
        }
    }
}