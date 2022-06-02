{
7. Realizar un programa que permita:
a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
El nombre del archivo de texto es: “novelas.txt”
b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
una novela y modificar una existente. Las búsquedas se realizan por código de novela.

NOTA: La información en el archivo de texto consiste en: código de novela,
nombre,género y precio de diferentes novelas argentinas. De cada novela se almacena la
información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
información: código novela, precio, y género, y la segunda línea almacenará el nombre
de la novela.   
   
}

program ejer7prac1;
type
  novela = record
    cod_novela: integer;
    precio: real;
    nombre: string;
    genero: string;
  end;
  
  archivoNovelas = file of novela;
  
procedure modificarNovela (var archNov: archivoNovelas);
//no se que modificar... voy a modificar el precio fue. 
var
  nov: novela;
  encontre: boolean;
  codigo: integer;
begin
  reset (archNov);
  write ('Ingrese el codigo de la novela a modificar: ');
  readln (codigo);
  encontre := false;
  while ((not eof (archNov)) and (not encontre)) do
    begin
      read (archNov, nov);
      if (nov.cod_novela = codigo) then
        begin
          encontre:= true;
          write ('Ingrese el nuevo precio: ');
          readln (nov.precio);
          seek (archNov, filePos (archNov) - 1 );
          write (archNov, nov);
        end;
    end;
  close (archNov);
end;
  
procedure leerNovela (var nov: novela);
begin
  with nov do
    begin
      write ('Ingrese codigo de novela: ');
      readln (cod_novela);
      write ('Ingrese nombre de novela: ');
      readln (precio);
      write ('Ingrese genero de novela: ');
      readln (genero);
      write ('Ingrese precio de novela: ');
      readln (precio);
    end;
end;
  
procedure agregarNovela (var archNov: archivoNovelas);
var
  nov: novela;
begin
  leerNovela (nov);
  reset (archNov);
  seek (archNov, filePos (archNov));
  write (archNov, nov);
  close (archNov);
end;
  
procedure importarInformacion (var archNov: archivoNovelas);
var
  nov: novela;
  archText: Text;
begin
  rewrite (archNov);
  
  assign (archText, 'novelas.txt');
  reset (archText);
  
  while (not(EOF(archText))) do
    begin
      write (not EOF(archText));
      readln (archText, nov.cod_novela, nov.precio, nov.nombre);
      readln (archText, nov.genero);
      write (archNov, nov);
    end;
  close(archNov);
  close(archText);
end;

procedure importarInformacion2 (var archNov: archivoNovelas; var archText: Text);
var
  linea:string;
begin 
  reset (archText);
  while not EOF(archText) do
    begin
      readln (archText, linea);
      writeln (linea);
    end;
  close (archText)


end;

function mostrarMenu: integer;
var
  opc: integer;
begin
  writeln ('-------------MENU--------------');
  writeln ('1. Importar a binario');
  writeln ('2. Agregar novela');
  writeln ('3. Modificar novela ');
  writeln ('------------------------------------------');
  writeln;
  write ('Ingrese el numero de operacion que desea realizar: ');
  readln (opc);
  mostrarMenu := opc;

end;

var 
  arch_novelas: archivoNovelas;
  opc: integer;
  
BEGIN
  opc := mostrarMenu();
  assign (arch_novelas, 'archivo_novelas_binario');
  case opc of
    1: importarInformacion (arch_novelas);
    2: agregarNovela (arch_novelas);
    3: modificarNovela (arch_novelas);
  end;
END.

