{
Generador de archivos para el ejercicio 4.
}


program ejer4prac2generador;
const
  valor_alto = 9999;
type

  fech = record
    dia: 1..32;
    mes: 1..13
  end;
  
  sesion = record
    cod_usuario: integer;
    fecha: fech;
    tiempo_sesion: integer;
  end;
  
  archivoSesiones = file of sesion;

procedure leerFecha (var f: fech);
begin
  write ('Ingrese el mes: ');
  readln (f.mes);
  write ('Ingrese dia: ');
  readln (f.dia);
end;

procedure leerSesion (var s: sesion);
begin
  write ('Ingrese codigo de usuario: ');
  readln (s.cod_usuario);
  if (s.cod_usuario <> valor_alto) then
    begin
      leerFecha (s.fecha);
      write ('Ingrese tiempo de sesion en minutos: ');
      readln (s.tiempo_sesion);
    end;
end;

procedure cargarDetalle (var arch_sesiones: archivoSesiones);
var
  s: sesion;
begin
  rewrite (arch_sesiones);
  leerSesion (s);
  while (s.cod_usuario <> valor_alto) do
    begin
      write (arch_sesiones, s);
      leerSesion (s);
    end;
  close (arch_sesiones);
end;
  
var 
  arch_sesiones : archivoSesiones;
  nom_arch_sesiones : string;
BEGIN
  write ('Ingrese el nombre del archivo: ');
  readln (nom_arch_sesiones);
  assign (arch_sesiones, nom_arch_sesiones);
  cargarDetalle (arch_sesiones);
END.

