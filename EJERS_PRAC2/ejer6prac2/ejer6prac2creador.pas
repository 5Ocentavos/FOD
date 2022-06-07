{
   
   
}


program ejer6prac2creador;
const
  cant_detalles = 10;
  valor_alto = 9999;
type
  info_municipio = record
    cod_localidad,
    cod_cepa: integer;
    cant_casos_activos,
    cant_casos_nuevos,
    cant_casos_recuperados,
    cant_casos_fallecimientos: integer;
  end;
  
  info_ministerio = record
    nom_localidad,
    nom_cepa: string;
    info_casos_total: info_municipio;
  end;
  
  archivoMunicipio = file of info_municipio;
  
  archivoMinisterio = file of info_ministerio;  


  
procedure mostrarInfo (m: info_municipio);
begin
  writeln ('Codigo localidad: ', m.cod_localidad);
  writeln ('Codigo cepa: ', m.cod_cepa);
  writeln ('Activos: ', m.cant_casos_activos);
  writeln ('Nuevos: ', m.cant_casos_nuevos);
  writeln ('Recuperados: ', m.cant_casos_recuperados);
  writeln ('Fallecimientos: ', m.cant_casos_fallecimientos);
  writeln;
end;
  
procedure imprimirArchivo (var arch_municipio: archivoMunicipio);
var
  m: info_municipio;
begin
  reset (arch_municipio);
  while (not eof (arch_municipio)) do
    begin
      read (arch_municipio, m);  
      mostrarInfo (m);
      writeln ();
    end;
  close (arch_municipio);
end;


procedure leerMunicipio (var m: info_municipio);
begin
  write ('Codigo localidad: ');
  readln (m.cod_localidad);
  if (m.cod_localidad <> valor_alto) then
    begin
      write ('Codigo cepa: ');
      readln (m.cod_cepa);
      write ('Activos: ');
      readln (m.cant_casos_activos);
      write ('Nuevos: ');
      readln (m.cant_casos_nuevos);
      write ('Recuperados: ');
      readln (m.cant_casos_recuperados);
      write ('Fallecimientos: ');
      readln (m.cant_casos_fallecimientos);
    end;
end;

procedure generarDetalle (var arch_municipio: archivoMunicipio);
var
  m: info_municipio;
begin
  rewrite (arch_municipio);
  leerMunicipio (m);
  while (m.cod_localidad <> valor_alto) do
    begin
      write (arch_municipio, m);
      leerMunicipio (m);
    end;
  close (arch_municipio);
end;

//************************************************************************

  
procedure mostrarInfoMaestro (m: info_ministerio);
begin
  writeln ('Nombre localidad: ', m.nom_localidad);
  writeln ('Nombre cepa: ', m.nom_cepa);
  mostrarInfo (m.info_casos_total);
  writeln;
end;

procedure imprimirArchivoMaestro (var arch_ministerio: archivoMinisterio);
var
  m: info_ministerio;
begin
  reset (arch_ministerio);
  while (not eof (arch_ministerio)) do
    begin
      read (arch_ministerio, m);  
      mostrarInfoMaestro (m);
      writeln ();
    end;
  close (arch_ministerio);
end;

procedure leerMinisterio (var m: info_ministerio);
begin
  leerMunicipio (m.info_casos_total);
  if (m.info_casos_total.cod_localidad <> valor_alto) then
    begin
      write ('Nombre localidad: ');
      readln (m.nom_localidad);
      write ('Nombre cepa: ');
      readln (m.nom_cepa);
    end;
end;

procedure generarMaestro (var arch_ministerio: archivoMinisterio);
var
  m: info_ministerio;
begin
  rewrite (arch_ministerio);
  leerMinisterio (m);
  while (m.info_casos_total.cod_localidad <> valor_alto) do
    begin
      write (arch_ministerio, m);
      leerMinisterio (m);
    end;
  close (arch_ministerio);
end;




function menuOpciones : integer;
var 
  opc: integer;
begin
  writeln ('-------------MENU--------------');
  writeln ('1. Generar archivo maestro');
  writeln ('2. Generar archivo detalle');
  writeln ('3. Imprimir archivo maestro');
  writeln ('4. Imprimir archivo detalle');
  writeln ('------------------------------------------');
  writeln;
  write ('Ingrese el numero de operacion que desea realizar: ');
  readln (opc);
  menuOpciones := opc;
end; 

var
  arch_maestro: archivoMinisterio;
  arch_detalle: archivoMunicipio;
  nomArch: string;
  opc: integer;
BEGIN
  opc := menuOpciones;
  writeln ();
  write ('Ingrese el nombre del archivo: ');
  readln (nomArch);
  case opc of
    1: begin
         assign (arch_maestro, nomArch); 
         generarMaestro (arch_maestro);
       end;
    2: begin
         assign (arch_detalle, nomArch); 
         generarDetalle (arch_detalle);
       end;
    3: begin
         assign (arch_maestro, nomArch); 
         imprimirArchivoMaestro (arch_maestro);
       end;
    4: begin
         assign (arch_detalle, nomArch); 
         imprimirArchivo (arch_detalle);
       end;     
  end;
END.
