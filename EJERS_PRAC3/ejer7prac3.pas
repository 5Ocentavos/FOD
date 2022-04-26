{
7. Se cuenta con un archivo que almacena información sobre especies de aves en
vía de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las especies a
eliminar. Deberá realizar todas las declaraciones necesarias, implementar todos los
procedimientos que requiera y una alternativa para borrar los registros. Para ello deberá
implementar dos procedimientos, uno que marque los registros a borrar y posteriormente
otro procedimiento que compacte el archivo, quitando los registros marcados. Para
quitar los registros se deberá copiar el último registro del archivo en la posición del registro
a borrar y luego eliminar del archivo el último registro de forma tal de evitar registros
duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000  
}


program ejer7prac3;
const 
  valor_corte = 500000;
type
  reg_ave = record
    codigo: longInt;
    nombre, familia, descripcion, zona_geografica: string;
  end;

  archivoAves = file of reg_ave;
  

  
procedure compactarArchivo (var arch_aves: archivoAves);
//Reemplazo el registro inicial solo si el ultimo registro no esta marcado,
//en caso de estar marcado, avanzo por izquierda hasta encontrar un registro
//final válido para reemplazar el registro inicial. 
var
  pos_a_truncar: integer;
  pos_a_reemplazar: integer;
  ave_inicio: reg_ave;
  ave_final: reg_ave;
//con un solo registro de tipo ave me hubiese bastado
begin
  reset (arch_aves);
  pos_a_reemplazar := 0;
  pos_a_truncar := fileSize (arch_aves);
  while (pos_a_reemplazar < (pos_a_truncar - 1)) do
    begin
      read (arch_aves, ave_inicio);
      //me guardo la posicion del registro a reemplazar
      pos_a_reemplazar := filePos (arch_aves) - 1;
      
      if (ave_inicio.codigo < 0) then
        begin        
          //tengo que leer el ultimo registro del archivo
          seek (arch_aves, (pos_a_truncar - 1));
          read (arch_aves, ave_final);
          //recorro el archivo por izquierda hasta encontrar un registro_final válido
          while  ((pos_a_reemplazar < (pos_a_truncar - 1)) and (ave_final.codigo < 0)) do
            begin
              pos_a_truncar := pos_a_truncar - 2;
              seek (arch_aves, pos_a_truncar);
              read (arch_aves, ave_final);
            end;
          if (ave_final.codigo > 0) then
            begin
              seek (arch_aves, pos_a_reemplazar);
              write (arch_aves, ave_final);
            end;
        end;
        
    end;
  seek (arch_aves, pos_a_truncar);
  truncate (arch_aves);
  close (arch_aves);
end;

function existeRegistro (codigo:longInt; var arch_aves:archivoAves): boolean; 
//esta funcion retorna true en caso de que el codigo del ave exista en el archivo
//dejando posicionado el puntero en ese registro para que sea posteriormente leido 
//en el metodo eliminarAves ([...]) (: 
var
  ave: reg_ave;
  encontre : boolean;
begin
  encontre := false;
  while (not EOF (arch_aves) and (not encontre)) do
    begin
      read (arch_aves, ave);
      if  (ave.codigo = codigo) then
        begin
          seek (arch_aves, filePos (arch_aves) - 1);
          encontre := true;
        end;
    end;
  existeRegistro := encontre;
end;
  
procedure eliminarAves (var arch_aves: archivoAves);
//este método elimina avES del archivo hasta leer el cod 500000
var
  ave: reg_ave;
  codigo: longInt;
begin
  reset (arch_aves);
  
  write ('Ingrese el codigo del ave: ');
  readln (codigo);
  
  while (codigo <> valor_corte) do
    begin
      if (existeRegistro (codigo, arch_aves)) then
        begin
          read (arch_aves, ave);
          ave.codigo := ave.codigo * - 1;              //mi criterio de borrado es que el codigo sea negativo
          seek (arch_aves, filePos (arch_aves) - 1);
          write (arch_aves, ave);
        end
      else
        writeln ('CODIGO INEXISTENTE');   
      write ('Ingrese el codigo del ave: ');
      readln (codigo);
      seek (arch_aves, 0);                             //
    end;
  close (arch_aves);
end;

procedure mostrar (ave: reg_ave);
begin
  writeln ('CODIGO: ',ave.codigo);
  writeln ('NOMBRE: ',ave.nombre);
  writeln ();
end;

procedure mostrarArchivo (var arch_aves: archivoAves);
var
  ave: reg_ave;
begin
  reset (arch_aves);
  while (not EOF (arch_aves)) do
    begin
      read (arch_aves, ave);
      mostrar (ave);
    end;
  close (arch_aves);
end;


procedure leerAve (var ave: reg_ave);
begin
  write ('CODIGO: ');
  readln (ave.codigo);
  write ('NOMBRE: ');
  readln (ave.nombre);
  //faltan leer cosas pero para que me esmero? 
end;

procedure agregarAve (var arch_aves: archivoAves);
var
  ave: reg_ave;
begin
  reset (arch_aves);
  leerAve (ave);
  seek (arch_aves, fileSize (arch_aves));
  write (arch_aves, ave);
  close (arch_aves);
end;

procedure crearArchivo (var arch_aves: archivoAves);
begin
  rewrite (arch_aves);
  close (arch_aves);
end;
  
function menuOpciones (): integer;
var
  opc: integer;
begin
  writeln ('***************MENU****************');
  writeln ('1. Crear archivo ');
  writeln ('2. Agregar ave');
  writeln ('3. Mostrar archivo');
  writeln ('4. Eliminar aves');
  writeln ('5. Compactar archivo');
  writeln ('*******************************');
  write ('Ingrese una opcion: ');
  readln (opc);
  writeln;
  if ((opc >0) and (opc < 6)) then
    menuOpciones := opc
  else
    begin 
      writeln ();
      write ('La opcion ingresada es invalida');
      menuOpciones := -1;  
    end;
end;
  
  
var 
  arch_aves: archivoAves;
  opc : integer;
BEGIN
  assign (arch_aves, 'archivo_aves'); //se cuenta con el archivo
  opc := menuOpciones ();
  case opc of
    1: crearArchivo (arch_aves);   // esto lo hago para ver como operan
    2: agregarAve (arch_aves);     // los métodos eliminar y compartar
    3: mostrarArchivo (arch_aves); // no son requeridos
    
    4: eliminarAves (arch_aves);
    5: compactarArchivo (arch_aves);
  end;
END.

