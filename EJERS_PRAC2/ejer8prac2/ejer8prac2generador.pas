{
   ejer8prac2generador.pas
   
   Copyright 2022 M.Angeles <M.Angeles@LAPTOP-DJHLU7P9>
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
   
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

procedure leerFecha (var f: reg_fecha);
begin
  write ('Anio: ');
  readln (f.anio);
  write ('Mes: ');
  readln (f.mes);
  write ('Dia: ');
  readln (f.dia);
end;  
  
procedure leerCliente (var c: reg_cliente);
begin
  write ('Codigo: ');
  readln (c.cod_cliente);
  if (c.cod_cliente <> valor_alto) then
    begin
      write ('Nombre: ');
      readln (c.nombre);
      write ('Apellido: ');
      readln (c.apellido);
    end;
end;

procedure leerVenta (var v: reg_venta);
begin
  leerCliente (v.cliente);
  if (v.cliente.cod_cliente <> valor_alto) then
    begin
      leerFecha (v.fecha);
      write ('Monto: ');
      readln (v.monto);
    end;
end;

procedure crearYcargar (var arch:archivoVentas);
var
  v: reg_venta;
begin
  rewrite (arch);
  leerVenta (v);
  while (v.cliente.cod_cliente <> valor_alto) do
    begin
      write (arch, v);
      leerVenta (v);
    end;
  close (arch);

end;  

var
  arch: archivoVentas;
BEGIN
  assign (arch, 'archivo_ventas');
  crearYcargar(arch);
END.

