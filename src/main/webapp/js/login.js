import { initializeApp } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-app.js";
import { getAuth, signInWithPopup, GoogleAuthProvider } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-auth.js";
import {FIREBASE_CONFIG} from "./env.js";

const app = initializeApp(FIREBASE_CONFIG);
const auth = getAuth(app);
const proveedorGoogle = new GoogleAuthProvider();

// Login con Google

document.getElementById("btnGoogle").addEventListener("click", () => {
    signInWithPopup(auth, proveedorGoogle)
        .then((resultado) => {
            // Si Google lo aprueba, sacamos su usuario
            const usuario = resultado.user;

            // Ya no lo guardamos en Firebase Database, simplemente lo mandamos a Java
            enviarTokenAJava(usuario);
        })
        .catch((error) => {
            console.error("Error en autenticación de Google:", error);
            alert("Inicio de sesión con Google cancelado.");
        });
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