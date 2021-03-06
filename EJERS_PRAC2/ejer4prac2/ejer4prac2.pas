{
4. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo dia en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log.   {es una ruta absoluta, debo crear la carpeta var y log}
}


program ejer4prac2;
uses SysUtils;
const 
  cant_maquinas = 5;
  valor_alto = 9999;
type
  
  sesion = record
    cod_usuario: integer;
    fecha: longint;           // si hubiera sabido antes de tu existencia... tambien funciona con str pero siempre con el formato añomesdia igual que el longint
    tiempo_sesion: integer;    
  end;
  
  archivoSesiones = file of sesion;
  
  vectorArchivoSesiones = array [1..cant_maquinas] of archivoSesiones;
  vectorRegistroSesiones = array [1..cant_maquinas] of sesion;

procedure mostrar (s:sesion);
begin
  writeln ('COD_USUARIO: ', s.cod_usuario);
  writeln ('FECHA: ', s.fecha);
  writeln ('TIEMPO_TOTAL_SESIONES: ', s.tiempo_sesion);
  writeln ('');
end;

procedure mostrarMaestro (var arch_maestro: archivoSesiones);
var
  s:sesion;
begin
  reset (arch_maestro);
  while (not EOF (arch_maestro)) do
    begin
      read (arch_maestro, s);
      mostrar (s);
    end;
  close (arch_maestro);
end;


procedure  closeVectorDetalles (var vec_arch_detalles: vectorArchivoSesiones);
var
  i: integer;
begin
  for i:= 1 to cant_maquinas do
    close (vec_arch_detalles[i]);
end;


  
procedure leerDetalle ( var arch_detalle: archivoSesiones; var reg_sesion: sesion);
begin
  if (not EOF (arch_detalle)) then
    read (arch_detalle, reg_sesion)
  else
    reg_sesion.cod_usuario := valor_alto;
end;



procedure minimo (var sesion_minima: sesion; var vec_reg_sesiones: vectorRegistroSesiones; var vec_arch_detalles: vectorArchivoSesiones);
var
  i, pos: integer;
begin
  sesion_minima.cod_usuario := valor_alto;
  sesion_minima.fecha := 99999999;
  for i := 1 to cant_maquinas do
    begin
      if (vec_reg_sesiones[i].cod_usuario <> valor_alto) then
        begin
          //writeln ('Maquina: ', i);
          //mostrar (vec_reg_sesiones[i]);
          if (vec_reg_sesiones[i].cod_usuario < sesion_minima.cod_usuario) then
            begin
              sesion_minima := vec_reg_sesiones [i];
              pos := i;
            end
          else
            if ((vec_reg_sesiones[i].cod_usuario = sesion_minima.cod_usuario) and (vec_reg_sesiones[i].fecha < sesion_minima.fecha)) then
              begin
                sesion_minima := vec_reg_sesiones [i];
                pos := i;
              end;
        end;
    end;
  if (sesion_minima.cod_usuario <> valor_alto) then
    begin
      leerDetalle (vec_arch_detalles[pos], vec_reg_sesiones[pos]);
    end;
end;



procedure cargarVectorRegistroSesiones (var vec_reg_sesiones: vectorRegistroSesiones; var vec_arch_detalles: vectorArchivoSesiones);
var
  i: integer;
begin
  for i:= 1 to cant_maquinas do
    begin
      leerDetalle (vec_arch_detalles[i], vec_reg_sesiones[i]);
    end;
end;


procedure resetVectorDetalles (var vec_arch_detalles: vectorArchivoSesiones);
var
  i: integer;
begin
  for i:= 1 to cant_maquinas do
    reset (vec_arch_detalles[i]);
end;


procedure crearMaestro (var arch_maestro: archivoSesiones; var vec_arch_detalles: vectorArchivoSesiones);
var
  sesion_minima: sesion;
  sesion_actual: sesion;
  vec_reg_sesiones: vectorRegistroSesiones;
begin
  rewrite (arch_maestro);
  resetVectorDetalles (vec_arch_detalles);
  cargarVectorRegistroSesiones (vec_reg_sesiones, vec_arch_detalles);
  minimo (sesion_minima, vec_reg_sesiones, vec_arch_detalles);
  while (sesion_minima.cod_usuario <> valor_alto) do
    begin
      sesion_actual.cod_usuario := sesion_minima.cod_usuario;
      sesion_actual.tiempo_sesion := 0;
      while (sesion_actual.cod_usuario = sesion_minima.cod_usuario) do
        begin
          sesion_actual.fecha := sesion_minima.fecha; //va a quedar con la ultima fecha
          sesion_actual.tiempo_sesion := sesion_actual.tiempo_sesion + sesion_minima.tiempo_sesion;
          minimo (sesion_minima, vec_reg_sesiones, vec_arch_detalles);
        end;
      write (arch_maestro, sesion_actual);
    end;
  close (arch_maestro);
  closeVectorDetalles (vec_arch_detalles);
end;


procedure assignVectorArchivoDetalles (var vec_arch_sesiones: vectorArchivoSesiones);
var
  i: integer;
begin
  for i:= 1 to cant_maquinas do
    assign (vec_arch_sesiones[i], 'sesiones_maquina_'+ IntToStr(i));
end;


var 
  arch_maestro: archivoSesiones;
  vec_arch_detalles: vectorArchivoSesiones;
  
BEGIN
  assign (arch_maestro, 'archivo_sesiones_totales'); ///Si hago el assign en la 'ubicacion fisica' var/log me da ERROR!
  assignVectorArchivoDetalles (vec_arch_detalles);
  crearMaestro (arch_maestro, vec_arch_detalles);
  writeln ();
  //assign (arch_maestro, 'archivo_sesiones_totales'); 
  //mostrarMaestro (arch_maestro);
END.

