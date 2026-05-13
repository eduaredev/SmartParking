import { initializeApp } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-app.js";
import { getAuth, createUserWithEmailAndPassword } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-auth.js";
import { getDatabase, ref, set } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-database.js";
import {FIREBASE_CONFIG} from "./env";

const app = initializeApp(FIREBASE_CONFIG);
const auth = getAuth(app);
const db = getDatabase(app);

// Recoleccion de datos, sirve para escribir lo que el usuario ingresó directamente en la autenticación de firebase

document.getElementById("formRegistro").addEventListener("submit", (e) => {e.preventDefault();

const nombre = document.getElementById("nombre").value;
const email = document.getElementById("email").value;
const password = document.getElementById("password").value;

createUserWithEmailAndPassword(auth, email, password).then((resultado) => {
    const uid = resultado.user.uid;
    return set(ref(db, 'usuarios/' + uid), {
        nombre: nombre,
        email: email,
        telefono: "",
        es_discapacitado: false,
        saldo_deudor: 0.0
    });
    }).then(() => {
        alert("Cuenta Creada");
        window.location.href = "login.jsp";
    }).catch((error) => {
        alert("Error al registrar: " + error);
        console.error(error);
    });

});