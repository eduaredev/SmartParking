package modelos;

import org.bson.Document;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Usuario implements Serializable {
    private String nombre;
    private String email;
    private String password;
    private String telefono;

    private boolean esDiscapacitado;
    private double saldoDeudor;
    private List<Vehiculos> vehiculos;

    //Constructor vacio osea sin parametros
    public Usuario() {
        this.vehiculos = new ArrayList<>();
        this.telefono = "";
        this.esDiscapacitado = false;
        this.saldoDeudor = 0.0;
    }

    // Constructor Registro
    public Usuario(String nombre, String email, String password) {
        this.nombre = nombre;
        this.email = email;
        this.password = password;
        this.telefono = "";
        this.esDiscapacitado = false;
        this.saldoDeudor = 0.0;
        this.vehiculos = new ArrayList<>();
    }
    // Constructor Login
    public Usuario(String nombre, String email, String password, String telefono, boolean esDiscapacitado, double saldoDeudor, List<Vehiculos> vehiculos ) {
        this.nombre = nombre;
        this.email = email;
        this.password = password;
        this.telefono = telefono;
        this.esDiscapacitado = esDiscapacitado;
        this.saldoDeudor = saldoDeudor;
        this.vehiculos = vehiculos;
    }

    // Getters y setters
    public String getNombre() {
        return nombre;
    }
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }

    public String getTelefono() {
        return telefono;
    }
    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public boolean isEsDiscapacitado() {
        return esDiscapacitado;
    }
    public void setEsDiscapacitado(boolean esDiscapacitado) { this.esDiscapacitado = esDiscapacitado; }

    public double getSaldoDeudor() { return saldoDeudor; }
    public void setSaldoDeudor(double saldoDeudor) { this.saldoDeudor = saldoDeudor; }

    public List<Vehiculos> getVehiculos() { return vehiculos; }
    public void setVehiculos(List<Vehiculos> vehiculos) { this.vehiculos = vehiculos; }

}
