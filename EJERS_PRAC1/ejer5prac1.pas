{
5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares, deben contener: código de celular, el nombre,
descripcion, marca, precio, stock mínimo y el stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo.

NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario
una única vez.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas: en la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”.
   
}


program tiendaCelulares;
type
  celular = record
    codCel: integer;
    precio: real;
    marca: string;
    stockDisp: integer;
    stockMin: integer;
    desc: string;
    nombre: string;
  end;
  
  archivoCelulares = file of celular;
  
procedure exportarArchBin (var archCel: archivoCelulares; var archText: text);
var
  cel: celular;
begin
  reset (archCel); 
  assign (archText, 'todosCelularesExpor.txt');
  rewrite (archText);
  while (not eof(archCel)) do
    begin
      read (archCel, cel);
      with cel do
        begin
          writeln(archText,codCel,' ',precio:4:2,' ', marca,' ',stockDisp,' ',stockMin, ' ', desc,' ', nombre);
        end;
    end;
  close (archCel);
  close (archText);
end;  

  
procedure mostrarInfo (cel: celular);
begin
  with cel do
    begin
      writeln ('CODIGO : ', codCel);
      writeln ('PRECIO: ',precio:3:0,'$');
      writeln ('MARCA:',marca);
      writeln ('STOCK DISPONIBLE: ',stockDisp);
      writeln ('STOCK MINIMO: ',stockMin);
      writeln ('DESCRIPCION: ',desc);
      writeln ('NOMBRE: ', nombre);
    end;
end;
  
  
procedure imprimirCelDesc (var archCel:archivoCelulares);
var
  cel: celular;
  descripcion: string;
begin
  write ('Ingrese una descripcion: ');
  readln (descripcion);
  reset (archCel);
  while (not eof (archCel)) do
    begin
      read (archCel, cel);
      if (cel.desc = descripcion) then
        mostrarInfo (cel);
    end;
  close (archCel); 
end;


procedure imprimirStockMin (var archCel: archivoCelulares);
var
  cel: celular;
begin
  reset (archCel);
  while (not eof (archCel)) do
    begin
      read (archCel, cel);
      if (cel.stockDisp < cel.stockMin) then
        mostrarInfo (cel);
    end;
  close (archCel); //no es necesario invocar a esta funcion ya que solo leimos los datos del archivo, no modificamos nada. 
end;

procedure crearYcargar (var archCel: archivoCelulares; var archText1: text);
var
  cel: celular;
begin
  rewrite (archCel);
  {Le asigno a mi archivo de texto su correspondiente ruta fisica}
  assign (archText1, 'celulares.txt');
  reset (archText1);
  {Hago la copia/trasferencia de datos de mi archivo txt a un archivo binario}
  while (not eof (archText1)) do
    begin
      with cel do
        begin
          readln (archText1, codCel, precio, marca);
          readln (archText1, stockDisp, stockMin, desc);
          readln (archText1, nombre); //que hace esto señora??
        end;
      write (archCel, cel);
    end;
  {Cierro los respectivos archivos}
  close (archCel);
  close (archText1);
end;

function mostrarMenu: integer;  
var 
  opc: integer;
begin
  writeln ('-------------MENU--------------');
  writeln ('1. Crear archivo y cargarlo');
  writeln ('2. Imprimir Stock Minimo');
  writeln ('3. Imprimir celulares con determinada descripcion ');
  writeln ('4. Importar archivo binario a text');	
  writeln ('------------------------------------------');
  write ('Ingrese el numero de operacion que desea realizar: ');
  readln (opc);
  writeln ();
  mostrarMenu := opc;
end; 


var 
  archCel: archivoCelulares;
  archText1: text;
  archText2: text;
  opc: integer;
  nomArch: string;
BEGIN
  {Leo el nombre fisico para mi archivo binario}
  write ('Ingrese el nombre del archivo: ');
  readln (nomArch);
  assign (archCel, nomArch);
  {Llamo a un metodo que muestra el menu con opciones y el leo una}
  opc := mostrarMenu;
  case opc of
    1: crearYcargar (archCel, archText1);
    2: imprimirStockMin (archCel);
    3: imprimirCelDesc (archCel);
    4: exportarArchBin (archCel, archText2);
  end;
END.

