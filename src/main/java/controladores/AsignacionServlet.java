package controladores;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.io.PrintWriter;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AsignacionServlet")
public class AsignacionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws javax.servlet.ServletException, java.io.IOException {
        // Aseguramos que el navegador sepa que SIEMPRE vamos a responder con JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Extraer parámetros enviados por JavaScript
            String origenX = request.getParameter("origen_x");
            String origenY = request.getParameter("origen_y");
            String destinoX = request.getParameter("destino_x");
            String destinoY = request.getParameter("destino_y");
            String cajonDeseado = request.getParameter("cajon_deseado");

            // Datos del usuario
            boolean esVip = Boolean.parseBoolean(request.getParameter("es_vip"));
            boolean esDiscapacitado = Boolean.parseBoolean(request.getParameter("es_discapacitado"));
            String tipoVehiculo = request.getParameter("tipo_vehiculo");

            // Construir la URL para llamar a Python
            String urlApi = String.format(
                    "http://localhost:5000/calcular_ruta?origen_x=%s&origen_y=%s&destino_x=%s&destino_y=%s&es_discapacitado=%b&tipo_vehiculo=%s&es_vip=%b&cajon_deseado=%s",
                    origenX, origenY, destinoX, destinoY, esDiscapacitado, tipoVehiculo, esVip, cajonDeseado
            );

            // Llamamos a Python mediante Flask
            URL url = new URL(urlApi);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            int responseCode = conn.getResponseCode();

            // Si Python responde OK
            if (responseCode == 200) {
                BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                String inputLine;
                StringBuilder content = new StringBuilder();
                while ((inputLine = in.readLine()) != null) {
                    content.append(inputLine);
                }
                in.close();
                out.print(content.toString()); // Enviar el JSON exitoso al JS
            } else {
                // Si Python mandó un error
                out.print("{\"status\": \"error\", \"mensaje\": \"Error de lógica en Python. Código HTTP: " + responseCode + "\"}");
            }

        } catch (java.net.ConnectException e) {
            out.print("{\"status\": \"error\", \"mensaje\": \"La API de Python está apagada. Por favor, ejecuta el script de Python.\"}");
        } catch (Exception e) {
            // Cualquier otro error de Java
            out.print("{\"status\": \"error\", \"mensaje\": \"Error en el servidor Java: " + e.getMessage() + "\"}");
        } finally {
            out.flush();
        }
    }
}