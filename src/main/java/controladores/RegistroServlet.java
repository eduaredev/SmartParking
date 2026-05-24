package controladores;

import DAO.UsuarioDAO;
import modelos.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validación de campos vacíos
        if (nombre == null || email == null || password == null || nombre.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("registro.jsp?error=ErrorGuardado");
            return;
        }

        Usuario nuevoUsuario = new Usuario(nombre, email, password);

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        if (usuarioDAO.registrarUsuario(nuevoUsuario)) {
            response.sendRedirect("login.jsp?mensaje=RegistroExitoso");
        } else {
            response.sendRedirect("registro.jsp?error=UsuarioExiste");
        }
    }
}