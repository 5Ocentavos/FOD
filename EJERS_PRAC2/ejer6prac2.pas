{
6- Se desea modelar la información necesaria para un sistema de recuentos de casos de
covid para el ministerio de salud de la provincia de buenos aires.

Diariamente se reciben archivos provenientes de los distintos municipios, la información 
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad casos
activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos. //ASUMO QUE EN UN MISMO DETALLE NO HAY INFORMACION REPETIDA EJ: |C.L 3 | C.L 3 |
                                                                            |C.C 2 | C.C 2 |
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad casos activos, cantidad casos
nuevos, cantidad recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.

Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.
 
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).
}


program ejer6prac2;
uses SysUtils;
const
  cant_detalles = 3;
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
  
  archivoMinisterio = file of info_ministerio;   // C.L 10 | C.L 10 | C.L 10 | C.L 9 | C.L 9 | C.L 9 | .....
                                                 // C.C 3  | C.C 2  | C.C 1  | C.C 3 | C.C 2 | C.C 1 | .....
                                                 
  vectorArchivosMunicipios = array [1..cant_detalles] of archivoMunicipio;

  vectorRegistrosMunicipios = array [1..cant_detalles] of info_municipio;

procedure closeVectorArchivosDetalles(var vec_arch_detalles: vectorArchivosMunicipios);
var
  i: integer;
begin
  for i:= 1 to cant_detalles do
    close (vec_arch_detalles[i]);
end;

procedure leerDetalle (var arch_detalle: archivoMunicipio; var reg_municipio: info_municipio);
begin
  if (not EOF(arch_detalle)) then
    read (arch_detalle, reg_municipio)
  else
    reg_municipio.cod_localidad := valor_alto;
end;


procedure minimo(var min_info_municipio:info_municipio; 
                 var vec_reg_detalles: vectorRegistrosMunicipios; 
                 var vec_arch_detalles: vectorArchivosMunicipios);
var
  i, 
  pos: integer;
begin
  min_info_municipio.cod_localidad := valor_alto;
  min_info_municipio.cod_cepa := valor_alto;
  
  for i:= 1 to cant_detalles do
    begin
      if (vec_reg_detalles[i].cod_localidad <> valor_alto) then
        begin
          if (vec_reg_detalles[i].cod_localidad <= min_info_municipio.cod_localidad) then
            begin
              if (vec_reg_detalles[i].cod_cepa < min_info_municipio.cod_cepa) then
                  begin
                    min_info_municipio := vec_reg_detalles[i];
                    pos := i;
                  end;
            end;
        end;
    end;
  
  if (min_info_municipio.cod_localidad <> valor_alto) then
      leerDetalle (vec_arch_detalles[pos], vec_reg_detalles[pos]);
end;

procedure inicializarVectorRegistrosDetalles (var vec_reg_detalles: vectorRegistrosMunicipios; var vec_arch_detalles: vectorArchivosMunicipios);
var
  i: integer;
begin
  for i := 1 to cant_detalles do
    begin
      leerDetalle (vec_arch_detalles[i], vec_reg_detalles[i]);
    end;
end;

procedure resetVectorArchivosDetalles(var vec_arch_detalles: vectorArchivosMunicipios);
var
  i: integer;
begin
  for i:= 1 to cant_detalles do
    reset (vec_arch_detalles[i]);
end;

procedure actualizarMaestro (var arch_maestro: archivoMinisterio; var vec_arch_detalles: vectorArchivosMunicipios);
var
  vec_reg_detalles: vectorRegistrosMunicipios;
  min_info_municipio, act_info_municipio: info_municipio;
  reg_ministerio: info_ministerio;
    
begin
  reset (arch_maestro);
  resetVectorArchivosDetalles (vec_arch_detalles);
  inicializarVectorRegistrosDetalles (vec_reg_detalles, vec_arch_detalles);
  minimo(min_info_municipio, vec_reg_detalles, vec_arch_detalles);

  while (min_info_municipio.cod_localidad <> valor_alto) do
    begin
      writeln ('entre');
      act_info_municipio.cod_localidad := min_info_municipio.cod_localidad;
      act_info_municipio.cod_cepa := min_info_municipio.cod_cepa;
      act_info_municipio.cant_casos_activos := 0;
      act_info_municipio.cant_casos_fallecimientos := 0;
      act_info_municipio.cant_casos_activos := 0;
      act_info_municipio.cant_casos_recuperados := 0;
      writeln (min_info_municipio.cod_localidad);
      
      while ((act_info_municipio.cod_localidad = min_info_municipio.cod_localidad) and (act_info_municipio.cod_cepa = min_info_municipio.cod_cepa )) do
        begin
            act_info_municipio.cant_casos_activos := act_info_municipio.cant_casos_activos + min_info_municipio.cant_casos_activos;
            act_info_municipio.cant_casos_fallecimientos := act_info_municipio.cant_casos_fallecimientos + min_info_municipio.cant_casos_fallecimientos;
            act_info_municipio.cant_casos_activos := min_info_municipio.cant_casos_activos;
            act_info_municipio.cant_casos_recuperados := min_info_municipio.cant_casos_recuperados;
            minimo(min_info_municipio, vec_reg_detalles, vec_arch_detalles);
        end;
        
      read (arch_maestro, reg_ministerio);
      while ((reg_ministerio.info_casos_total.cod_localidad <> act_info_municipio.cod_localidad) and (reg_ministerio.info_casos_total.cod_cepa <> act_info_municipio.cod_cepa)) do
        read (arch_maestro, reg_ministerio);
          
      seek (arch_maestro, filePos(arch_maestro)-1);
      reg_ministerio.info_casos_total := act_info_municipio;
      write (arch_maestro, reg_ministerio);
    end;
  
  close(arch_maestro);
  closeVectorArchivosDetalles(vec_arch_detalles);
end;

procedure assignVectorArchivosDetalles(var vec_arch_detalles: vectorArchivosMunicipios);
var
  i: integer;
  nom: string;
begin
  for i:= 1 to cant_detalles do
    begin
      nom := 'archivo_municipio_' + IntToStr(i);
      assign (vec_arch_detalles[i], nom);
    end;
end;
  
var 
  vec_arch_detalles: vectorArchivosMunicipios;
  arch_maestro: archivoMinisterio;  

BEGIN
  assign(arch_maestro, 'archivo_ministerio');
  assignVectorArchivosDetalles(vec_arch_detalles);
  actualizarMaestro(arch_maestro, vec_arch_detalles);
  //informarLocalidades50CasosActivos(arch_maestro);
  writeln('ARCHIVO MAESTRO ACTUALIZADO!');
END.

