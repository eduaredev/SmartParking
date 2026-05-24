package modelos;

import java.io.Serializable;

public class Vehiculos implements Serializable {

    private String placa;
    private String marca;
    private String modelo;
    private String color;
    private TipoVehiculo tipo;

    //Constructor vacio
    public Vehiculos() {}

    public Vehiculos(String placa, String marca, String modelo, String color, TipoVehiculo tipo) {
        this.placa = placa;
        this.marca = marca;
        this.modelo = modelo;
        this.color = color;
        this.tipo = tipo;
    }

    // Getters y Setters
    public String getPlaca() { return placa; }
    public void setPlaca(String placa) { this.placa = placa; }

    public String getMarca() { return marca; }
    public void setMarca(String marca) { this.marca = marca; }

    public String getModelo() { return modelo; }
    public void setModelo(String modelo) { this.modelo = modelo; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public TipoVehiculo getTipo() { return tipo; }
    public void setTipo(TipoVehiculo tipo) { this.tipo = tipo; }

}
