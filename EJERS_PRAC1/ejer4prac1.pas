{
4. Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir una o más empleados al final del archivo con sus datos ingresados por
teclado.
b. Modificar edad a una o más empleados.
c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado.
   
}


program ejer4prac1;
type
  empleado = record
    numEmp: integer;
    apellido: string;
    nombre: string;
    edad: integer;
    dni: string;
  end;

  archivoEmpleados = file of empleado;


procedure lecturaYEnlaceDelArchivo (var archEmp: archivoEmpleados);
var
  nomArch: string;
begin
  write ('Ingrese el nombre del archivo a procesar: ');
  readln (nomArch);
  assign (archEmp, nomArch);
  writeln;
end;
  
procedure exportarArchTextNoDni (var archEmp: archivoEmpleados; var archText2: text);
var
  emp: empleado; 
begin
  reset (archEmp);
  assign (archText2, 'faltaDNIEmpleado.txt');
  rewrite (archText2);
  while (not eof(archEmp)) do
    begin
      read (archEmp, emp);
      if (emp.dni = '00') then
        with emp do
          writeln(archText2,' ',numEmp,' ',apellido,' ', nombre,' ',edad,' ',dni);
    end;
  close (archEmp);
  close (archText2);
end;

procedure exportarArchText (var archEmp: archivoEmpleados; var archText : text);
var
  emp: empleado; 
begin
  reset (archEmp);
  {Le asigno a archText la ruta donde se van a guardar los datos que lea de archEmp}
  assign (archText, 'todosEmpleados.txt');
  rewrite (archText);
  while (not eof(archEmp)) do
    begin
      read (archEmp, emp);
      with emp do
        writeln(archText,' ',numEmp,' ',apellido,' ', nombre,' ',edad,' ',dni);
    end;
  close (archEmp);
  close (archText);
end;

function leerEdad : integer;
var
  edad: integer;
begin
  write ('Ingrese la edad: ');
  readln (edad);
  leerEdad := edad;
end;

function leerNumEmpleado : integer;
var
  num: integer;
begin
  write ('Ingrese el numero de empleado <-1 para terminar>: ');
  readln (num);
  leerNumEmpleado := num;
end;

procedure modificarEdadesSimple (var archEmp: archivoEmpleados); 
//Con tener un metodo que modifique una sola edad ya estaba bien, 
//no borro este metodo porque me costo un ovario y una neurona sacarlo  //Fer me dijo que esta bien porque el insiso dice "una o más" no "un"
var
  emp: empleado;
  encontre : boolean;
  numEmp : integer;
begin
  encontre := false;
  reset (archEmp);
  numEmp := leerNumEmpleado();
  
  while (numEmp <> -1) do
    begin
      while ((not EOF(archEmp)) and (not (encontre))) do
        begin
          read (archEmp, emp);
          if (emp.numEmp = numEmp) then
            begin
              encontre := true;
              emp.edad:= leerEdad;
              seek (archEmp, filePos(archEmp) -1);
              write (archEmp, emp);
            end;
        end;
      numEmp := leerNumEmpleado();
      seek (archEmp, 0);
    end;
  close (archEmp);
end;
  
  

procedure modificarEdades (var archEmp: archivoEmpleados); 
//Con tener un metodo que modifique una sola edad ya estaba bien, 
//no borro este metodo porque me costo un ovario y una neurona sacarlo  //Fer me dijo que esta bien porque el insiso dice "una o más" no "un"
var
  emp: empleado;
  existeEmp : boolean;
  encontre : boolean;
  numEmp : integer;
begin
  encontre := false;
  existeEmp := true;

  reset (archEmp);
  while existeEmp do 
    begin
      numEmp := leerNumEmpleado;
      encontre := false;
      while ((not eof (archEmp)) and (not encontre)) do
        begin
          read (archEmp, emp);
          if (emp.numEmp = numEmp) then
            begin
              encontre := true;
              emp.edad:= leerEdad;
              seek (archEmp, (filePos(archEmp) - 1));
              write (archEmp, emp);
              {reestablesco la posicion del puntero al inicio del archivo}
              seek (archEmp, 0);
            end;
        end;
      if (not encontre)then
        existeEmp := false; 
    end;
  close (archEmp);
end;


procedure leerEmpleado (var emp: empleado);
begin
  with emp do
    begin
      write ('Ingrese el apellido: ');
      readln (apellido);
      if (apellido <> 'fin') then
        begin
          write ('Ingrese el nombre: ');
          readln (nombre);
          write ('Ingrese el numero de empleado: ');
          readln (numEmp);
          write ('Ingrese la edad: ');
          readln (edad);
          write ('Ingrese el dni: ');
          readln (dni);
        end;
    end;
end;
  

procedure agregarEmpleados (var archEmp: archivoEmpleados);
var
  emp: empleado;
begin
  reset (archEmp);
  seek (archEmp, fileSize (archEmp)); //hay una opcion que te posiciona al final del archivo, no recuerdo como me dijo que se llamaba el ruso
  leerEmpleado (emp);
  while (emp.apellido <> 'fin') do
    begin
      write (archEmp, emp);
      leerEmpleado (emp);
    end;
  close (archEmp);
end;
   
  


procedure mostrarEmpleado (emp:empleado);
begin
  writeln;
  writeln ('NOMBRE: ',emp.nombre);
  writeln ('APELLIDO: ',emp.apellido );
  writeln ('NUMERO DE EMPLEADO: ',emp.numEmp );
  writeln ('DNI: ',emp.dni );
  writeln ('EDAD: ', emp.edad );
  writeln;
end;
   

procedure listarEmpleadosMayores70 (var archEmp: archivoEmpleados);
var
  emp: empleado;
begin
  reset (archEmp);
  while (not eof (archEmp)) do
    begin
      read (archEmp, emp);
      if (emp.edad >= 70) then
        mostrarEmpleado (emp);
    end;
  close (archEmp);
end;

procedure listarEmpleadosDeterminados (var archEmp: archivoEmpleados);
var
  emp: empleado;
  nomOape: string;
begin
  reset (archEmp);
  write ('Ingrese un nombre o apellido: ');
  readln (nomOape);
  while (not eof (archEmp)) do
    begin
      read (archEmp, emp);
      if ((emp.nombre = nomOape) or (emp.apellido = nomOape)) then
        mostrarEmpleado (emp);
    end;
  close (archEmp);
end;


procedure listarEmpleados (var archEmp: archivoEmpleados);
var
  emp: empleado;
begin
  reset (archEmp);
  while (not eof (archEmp)) do
    begin
      read (archEmp, emp);
      mostrarEmpleado (emp);
    end;
  close (archEmp);
end;


  
procedure creacionYcarga (var archEmp: archivoEmpleados);
var
  emp: empleado;
begin
  {Creo el archivo}
  rewrite (archEmp);
  {Leo y agrego empleados a mi archivo}
  leerEmpleado (emp);
  while (emp.apellido <> 'fin') do
    begin
      write (archEmp, emp);
      leerEmpleado (emp);
    end;
  {Transfiero la informacion leida a la ruta que esta enlazada con archEmp}
  close (archEmp);
end;

  
function mostrarMenu: integer;  
var 
  opc: integer;
begin
  writeln ('-------------MENU--------------');
  writeln ('1. Crear archivo de empleados y cargarlo');
  writeln ('2. Listar empleados');
  writeln ('3. Listar en pantalla los empleados con un nombre o apellido determinado ');
  writeln ('4. Listar empleados mayores a 70 anios');	
  writeln ('5. Agregar empleados al archivo');
  writeln ('6. Modificar edad');
  writeln ('7. Exportar a txt');
  writeln ('8. Exportar a txt solo los empleados sin dni');
  writeln ('------------------------------------------');
  write ('Ingrese el numero de operacion que desea realizar: ');
  readln (opc);
  mostrarMenu := opc;
end; 

var
  archEmp: archivoEmpleados;
  opc: integer;
  archText: text;
  archText2: text;
BEGIN
  opc := mostrarMenu;
  lecturaYEnlaceDelArchivo (archEmp);
  case opc of
    1: creacionYcarga (archEmp);
    2: listarEmpleados (archEmp);
    3: listarEmpleadosDeterminados (archEmp);
    4: listarEmpleadosMayores70 (archEmp);
    5: agregarEmpleados (archEmp);
    6: modificarEdadesSimple (archEmp);
    7: exportarArchText (archEmp, archText);
    8: exportarArchTextNoDni (archEmp, archText2);
  end;
END.

