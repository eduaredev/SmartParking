package config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import java.util.Properties;

import java.io.InputStream;

public class Conexion {
    // Variable para no inicializar a firebase mas de una vez
    private static boolean inicio = false;
    private static MongoClient mongoClient = null;
    private static MongoDatabase database = null;

    public static void iniciarconexiones(){
        //Este es para firebase
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
        if(mongoClient == null){
            try {
                // Instanciamos Properties nativo de Java
                Properties props = new Properties();
                // Buscamos el archivo en la carpeta resources
                InputStream in = Conexion.class.getClassLoader().getResourceAsStream("config.properties");

                if (in == null) {
                    System.err.println("No se encontró el archivo config.properties");
                    return;
                }

                // Cargamos el archivo y obtenemos la URI
                props.load(in);
                String uri = props.getProperty("MongoURI");

                if(uri == null || uri.isEmpty()){
                    System.err.println("No se encontró la variable MongoURI");
                    return;
                }

                // Conectamos a Mongo
                mongoClient = MongoClients.create(uri);
                database = mongoClient.getDatabase("DAW_SMARTPARKING");

            } catch (Exception e) {
                System.err.println("Error al conectar con la base de datos de Mongo: " + e.getMessage());
            }
        }
    }
    public static MongoDatabase getDatabase(){
        if(database==null){
            iniciarconexiones();
        }
        return database;
    }
}
