package modelos;

import java.util.UUID;

public class Vehiculos {
    private String idvehiculo;
    private String usuarioId;
    private String placa;
    private String marca;
    private String modelo;
    private String color;
    private TipoVehiculo tipo;
    private boolean activo;

    // Constructor vacío
    public Vehiculos() {
        // Genera un ID único para poder identificar este coche en el arreglo de Mongo
        this.idvehiculo = UUID.randomUUID().toString();
    }

    // Constructor con parámetros
    public Vehiculos(String usuarioId, String placa, String marca, String modelo, String color, TipoVehiculo tipo, boolean activo) {
        this.idvehiculo = UUID.randomUUID().toString();
        this.usuarioId = usuarioId;
        this.placa = placa;
        this.marca = marca;
        this.modelo = modelo;
        this.color = color;
        this.tipo = tipo;
        this.activo = activo;
    }

    // Getters y Setters
    public String getIdvehiculo() {
        return idvehiculo;
    }

    public void setIdvehiculo(String idvehiculo) {
        this.idvehiculo = idvehiculo;
    }

    public String getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(String usuarioId) {
        this.usuarioId = usuarioId;
    }

    public String getPlaca() {
        return placa;
    }

    public void setPlaca(String placa) {
        this.placa = placa;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getModelo() {
        return modelo;
    }

    public void setModelo(String modelo) {
        this.modelo = modelo;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public TipoVehiculo getTipo() {
        return tipo;
    }

    public void setTipo(TipoVehiculo tipo) {
        this.tipo = tipo;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }
}