package controladores;

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
        Conexion.iniciarfirebase();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Recibimos el Token desde login.js
        String idToken = request.getParameter("idToken");

        if (idToken == null || idToken.isEmpty()) {
            System.err.println("Error: No se recibió ningún token de Firebase.");
            response.sendRedirect("login.jsp?error=FaltaToken");
            return;
        }

        try {
            // Verificamos que el Token sea real y haya sido emitido por Google
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);

            // Extraemos el ID único del usuario (UID)
            String uid = decodedToken.getUid();

            // Creamos la sesión en Tomcat
            HttpSession session = request.getSession();
            session.setAttribute("usuario_uid", uid);

            System.out.println("Sesión iniciada correctamente para el UID: " + uid);
            response.sendRedirect("dashboard.jsp");

        } catch (Exception e) {
            // Si alguien intenta falsificar un token, el servidor lo rechaza
            System.err.println("Error de seguridad: Token inválido. " + e.getMessage());
            response.sendRedirect("login.jsp?error=TokenInvalido");
        }
    }
}