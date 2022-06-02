{
1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese el número 30000, que no debe incorporarse al archivo.
   
}


program archivoNumerosCreacionYCarga;
const
  corte = 30000;
type
  archivoNumeros = file of longint;

procedure crearYcargarArchivo (var arch_num: archivoNumeros);
var
  num: integer;
begin
  {Creo el archivo efectivo}
  rewrite (arch_num);
  {Leo numeros y los cargo en el archivo}
  write ('Ingrese un numero entero: ');
  readln (num);
  while (num <> 30000) do
    begin
      write (arch_num, num);
      write ('Ingrese un numero entero: ');
      readln (num);
    end;
  {Además de cerrar el archivo, el método close, me trasfiere la información de memoria principal a memoria secuandaria o disco}
  close (arch_num);
end;

var 
  arch_num : archivoNumeros;
  nom_arch: string;

BEGIN
  {Leo el nombre del archivo}
  write ('Ingrese el nombre del archivo: ');
  readln (nom_arch);
  {Hago el enlace de mi archivo binario con la ruta que ingreso el usuario}
  assign (arch_num, nom_arch);
  {Llamo al método crear y cargar}
  crearYcargarArchivo (arch_num);
END.

