{
2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y
el promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.   
}


program analisisDeArchivoCreadoEnEjer1;
type
  archivoNumeros = file of longint;


procedure procesarArchivo (var arch_num: archivoNumeros; var cant_num_menores: integer; var promedio:real);
var
  num: longint;
begin
  reset (arch_num);
  promedio := 0;
  cant_num_menores := 0;
  while (not eof (arch_num)) do
    begin
      read (arch_num, num);
      writeln (num);
      if (num < 1500) then
        cant_num_menores := cant_num_menores +1;
      promedio := promedio + num;
    end;
  promedio := promedio/fileSize(arch_num);  
  close (arch_num);
end;

var 
  arch_num: archivoNumeros;
  nom_arch: string;
  cant_num_menores: integer;
  promedio: real;
  //cant_num: integer; //no es necesario, puedo hacer suma_total/fileSize(arch_num)
BEGIN
  {El nombre de archivo ingresado de teclado puede ser erroneo pero vamos a suponer que es válido
    ya que la catedra asi lo dijo, mas especificamente Emmanuel}
  write ('Ingrese el nombre del archivo a procesar: ');
  readln (nom_arch);
  assign (arch_num, nom_arch);
  {En el metodo procesar archivo voy a usar la operacion read y close para ser elegante}
  procesarArchivo (arch_num, cant_num_menores, promedio);
  {Imprimo en pantalla los resultados del procesamiento de los datos del archivo}
  writeln ('CANTIDAD DE NUMEROS MENORES A 1500: ', cant_num_menores);
  writeln ('PROMEDIO NUMEROS INGRESADOS ES: ', promedio:3:2);
END.

