import { initializeApp } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-app.js";
import { getAuth, signInWithEmailAndPassword, signInWithPopup, GoogleAuthProvider } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-auth.js";
import { getDatabase, ref, get, set } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-database.js";
import {FIREBASE_CONFIG} from "./env";

const app = initializeApp(FIREBASE_CONFIG);
const auth = getAuth(app);
const db = getDatabase(app);
const proveedorGoogle = new GoogleAuthProvider();

// Login con Email y Password

document.getElementById("formLogin").addEventListener("submit", (e) => {
    e.preventDefault();
    const email = document.getElementById("email").value;
    const password = document.getElementById("password").value;

    signInWithEmailAndPassword(auth, email, password)
        .then((resultado) => enviarTokenAJava(resultado.user))
        .catch((error) => alert("Error: Correo o contraseña incorrectos."));
});

// Login con Google

document.getElementById("btnGoogle").addEventListener("click", () => {
    signInWithPopup(auth, proveedorGoogle)
        .then((resultado) => {
            const usuario = resultado.user;
            const usuarioRef = ref(db, 'usuarios/' + usuario.uid);

            // Verificamos si existe el usuario con get(UsuarioRef)
            get(usuarioRef).then((snapshot) => {
                if (snapshot.exists()) {
                    // Si existe, mandamos las credenciales del usuario a la función enviarTokenKava que conecta directamente con el servlet UsarioDAO
                    // pero convertido en un JWT (Jason Web Token)
                    enviarTokenAJava(usuario);
                } else {
                    // Si es nuevo. Le creamos su perfil silenciosamente sin teléfono
                    set(usuarioRef, {
                        nombre: usuario.displayName, //Para obtener el nombre desde de la cuenta de Google
                        email: usuario.email,
                        telefono: "",
                        es_discapacitado: false,
                        saldo_deudor: 0.0
                    }).then(() => {
                        enviarTokenAJava(usuario);
                    });
                }
            });
        })
        .catch((error) => alert("Inicio de sesión con Google cancelado."));
});

function enviarTokenAJava(usuario) {
    usuario.getIdToken().then((token) => {
        const formOculto = document.createElement('form');
        formOculto.method = 'POST';
        formOculto.action = 'LoginServlet';

        const inputToken = document.createElement('input');
        inputToken.type = 'hidden';
        inputToken.name = 'idToken';
        inputToken.value = token;

        formOculto.appendChild(inputToken);
        document.body.appendChild(formOculto);
        formOculto.submit();
    });
}