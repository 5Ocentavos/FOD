{
   
   
}


program ejer8prac2;
const 
  valor_alto = 9999;
type
  reg_cliente = record
    cod_cliente: integer;
    nombre,
    apellido: string
  end;
  
  reg_fecha = record
    anio: integer;
    mes: integer;
    dia: integer;
  end;
  
  reg_venta = record
    cliente: reg_cliente;
    fecha : reg_fecha;
    monto: real;
  end;
  
  archivoVentas = file of reg_venta;

procedure datosCliente (c:reg_cliente);
begin
  writeln ('NOMBRE: ', c.nombre);
  writeln ('APELLIDO: ', c.apellido);
  writeln ('CODIGO: ', c.cod_cliente);
end;

procedure leerArchivo (var arch: archivoVentas; var venta: reg_venta);
begin
  if (not EOF (arch)) then
    read (arch, venta)
  else
    venta.cliente.cod_cliente := 9999;
end;

procedure reporteVentas (var arch_ventas: archivoVentas);
var
  venta: reg_venta;
  cod_cliente: integer;
  anio, mes: integer;
  monto_total_empresa,
  monto_total_anio,
  monto_total_mes: real;
begin
  reset (arch_ventas);
  leerArchivo (arch_ventas, venta);
  monto_total_empresa := 0;
  while (venta.cliente.cod_cliente <> valor_alto) do
    begin
      datosCliente (venta.cliente);
      cod_cliente := venta.cliente.cod_cliente;
      while (cod_cliente = venta.cliente.cod_cliente) do
        begin
          anio := venta.fecha.anio;
          monto_total_anio := 0;
          while (cod_cliente = venta.cliente.cod_cliente) and (anio = venta.fecha.anio) do
            begin
              mes := venta.fecha.mes;
              monto_total_mes := 0;
              while  ((cod_cliente = venta.cliente.cod_cliente) and (anio = venta.fecha.anio) and (mes = venta.fecha.mes)) do
                begin
                  monto_total_mes := monto_total_mes + venta.monto;
                  leerArchivo (arch_ventas, venta);
                end;
              writeln ('GASTO MENSUAL: ', monto_total_mes:4:2, '$');
              monto_total_anio := monto_total_anio + monto_total_mes;
            end;
          writeln ('GASTO ANUAL: ', monto_total_anio:4:2, '$');
          monto_total_empresa := monto_total_empresa + monto_total_anio;
        end;
    end;
  write ('RECAUDACION TOTAL: ',monto_total_empresa:4:2,'$');
  close (arch_ventas);
end;




var 
  arch_ventas: archivoVentas;
BEGIN
  assign (arch_ventas, 'archivo_ventas');
  reporteVentas (arch_ventas);
END.

