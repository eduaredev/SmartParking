package modelos;

import java.util.List;

public class Plaza {
    private String idPlaza;
    private String nombre;
    private String direccion;
    private List<Double> coordenadas;
    private String precio;
    private String flujo;

    // Constructor vacío
    public Plaza() {}

    // Constructor con parámetros
    public Plaza(String idPlaza, String nombre, String direccion, List<Double> coordenadas, String precio, String flujo) {
        this.idPlaza = idPlaza;
        this.nombre = nombre;
        this.direccion = direccion;
        this.coordenadas = coordenadas;
        this.precio = precio;
        this.flujo = flujo;
    }

    // Getters
    public String getIdPlaza() { return idPlaza; }
    public String getNombre() { return nombre; }
    public String getDireccion() { return direccion; }
    public List<Double> getCoordenadas() { return coordenadas; }
    public String getPrecio() { return precio; }
    public String getFlujo() { return flujo; }
}