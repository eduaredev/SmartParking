package controladores;

import DAO.UsuarioDAO;
import modelos.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/PerfilServlet")
public class PerfilServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Para que lea bien los acentos
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Usuario usuarioActual = (Usuario) session.getAttribute("usuarioLogueado");

        if (usuarioActual != null) {
            // Recibimos los datos del formulario
            String nombre = request.getParameter("nombre");
            String telefono = request.getParameter("telefono");

            // Si está marcado, manda "true"
            boolean esDiscapacitado = request.getParameter("esDiscapacitado") != null;

            boolean esVip = request.getParameter("esVip") != null;

            // Guardamos en MongoDB
            UsuarioDAO dao = new UsuarioDAO();
            boolean actualizado = dao.actualizarPerfil(usuarioActual.getId(), nombre, telefono, esDiscapacitado, esVip);

            if (actualizado) {
                usuarioActual.setNombre(nombre);
                usuarioActual.setTelefono(telefono);
                usuarioActual.setEsDiscapacitado(esDiscapacitado);
                usuarioActual.setEsVip(esVip);
                session.setAttribute("usuarioLogueado", usuarioActual);
            }
        }

        response.sendRedirect("perfil.jsp");
    }
}
