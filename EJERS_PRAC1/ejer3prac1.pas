{
3. Realizar un programa que presente un menú con opciones para:

a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario una
única vez.
   
}
program ejer3prac1;
type
  empleado = record
    numEmp: integer;
    apellido: string;
    nombre: string;
    edad: integer;
    dni: string;
  end;

  archivoEmpleados = file of empleado;
  
  
procedure leerNombreDelArchivoYEnlazarlo (var archEmp: archivoEmpleados);
var
  nomArch: string;
begin
  write ('Ingrese el nombre del archivo a procesar: ');
  readln (nomArch);
  assign (archEmp, nomArch);
  writeln;
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
  
procedure creacionYcarga (var archEmp: archivoEmpleados);
var
  emp: empleado;
begin
  rewrite (archEmp);
  {Leo y agrego empleados a mi archivo}
  leerEmpleado (emp);
  while (emp.apellido <> 'fin') do
    begin
      write (archEmp, emp);
      leerEmpleado (emp);
    end;
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
  writeln ('------------------------------------------');
  write ('Ingrese la operacion que desea realizar: ');
  readln (opc);
  mostrarMenu := opc;
end; 

var
  archEmp: archivoEmpleados;
  opc: integer;
BEGIN
  opc := mostrarMenu;
  leerNombreDelArchivoYEnlazarlo (archEmp); 
  case opc of
    1: creacionYcarga (archEmp);
    2: listarEmpleados (archEmp);
    3: listarEmpleadosDeterminados (archEmp);
    4: listarEmpleadosMayores70 (archEmp);
  end;
END.

