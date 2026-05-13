package config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

import java.io.InputStream;

public class Conexion {
    // Variable para no inicializar a firebase mas de una vez
    private static boolean inicio = false;

    public static void iniciarfirebase(){
        if(!inicio){
            try{
                InputStream serviceAccount = Conexion.class.getClassLoader().getResourceAsStream("smartparking-firebase-key.json");

                if(serviceAccount == null){
                    System.err.println("No se encontro el archivo para firebase");
                    return;
                }
                FirebaseOptions options = FirebaseOptions.builder().setCredentials(GoogleCredentials.fromStream(serviceAccount)).setDatabaseUrl("https://smartparking-db-91cce-default-rtdb.firebaseio.com/").build();

                FirebaseApp.initializeApp(options);
                inicio = true;

            }catch (Exception e){
                System.err.println("Error al conector con firebase" + e);
            }
        }
    }

}
