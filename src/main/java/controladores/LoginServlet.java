package controladores;

import DAO.UsuarioDAO;
import modelos.Usuario;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import config.Conexion;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;


@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    // Metodo para inicializar Firebase al prender el servlet
    @Override
    public void init() throws ServletException {
        Conexion.iniciarconexiones();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // Deteccion de acentos y ñ, encoding

        String idToken = request.getParameter("idToken");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        HttpSession session = request.getSession();
        UsuarioDAO usuarioDAO = new UsuarioDAO();

        if (idToken != null && !idToken.isEmpty()) {
            try {
                // Desencriptamos el token de Google
                FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
                String googleEmail = decodedToken.getEmail();
                String googleNombre = decodedToken.getName();

                // Si el usuario no tiene nombre público en Google, asignamos uno genérico
                if(googleNombre == null || googleNombre.isEmpty()){
                    googleNombre = "Usuario de Google";
                }

                // Buscamos si ya está registrado en MongoDB
                Usuario usuarioValidado = usuarioDAO.buscarPorEmail(googleEmail);

                // Si no existe, lo creamos y lo insertamos en Mongo
                if (usuarioValidado == null) {
                    usuarioValidado = new Usuario(googleNombre, googleEmail, "GOOGLE_AUTH");
                    usuarioDAO.registrarUsuario(usuarioValidado);
                }

                session.setAttribute("usuarioLogueado", usuarioValidado);
                session.setAttribute("metodo_login", "google");

                response.sendRedirect("dashboard.jsp");

            } catch (Exception e) {
                System.err.println("Error Firebase: " + e.getMessage());
                response.sendRedirect("login.jsp?error=TokenInvalido");
            }
        }

        else if (email != null && !email.isEmpty() && password != null && !password.isEmpty()) {

            Usuario usuarioValidado = usuarioDAO.validarLogin(email, password);

            if (usuarioValidado != null) {
                session.setAttribute("usuarioLogueado", usuarioValidado);
                session.setAttribute("metodo_login", "tradicional");
                response.sendRedirect("dashboard.jsp");
            } else {
                response.sendRedirect("login.jsp?error=CredencialesInvalidas");
            }
        }
        else {
            response.sendRedirect("login.jsp?error=DatosIncompletos");
        }

    }
}