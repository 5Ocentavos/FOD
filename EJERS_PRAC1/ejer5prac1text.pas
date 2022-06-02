{
   
   
}


program ejer5prac1text;

procedure leerFichero (var fichero: text);
var 
    linea: string;      (* La linea que leeremos *)

begin 
    assign( fichero, 'todosCelulares.txt' );  (* Le asignamos nombre *) 
    reset( fichero );                (* Lo abrimos para leer datos *) 
    while not eof( fichero) do
    begin
        readLn( fichero, linea );    (* Leemos una linea *)
        writeLn( linea );            (* Y la mostramos *) 
    end;
    close( fichero );                (* Finalmente cerramos *) 
end;

var
  archivoCelularesText : text;

BEGIN
  assign (archivoCelularesText, 'todoCelulares.txt');
  rewrite (archivoCelularesText);
  writeln (archivoCelularesText, '76643 39827 MOTOROLA');
  writeln (archivoCelularesText, '67 2 Posee una camara frontal buena');
  writeln (archivoCelularesText, 'A16U');
  writeln (archivoCelularesText, '28329 99827 SAMSUNG');
  writeln (archivoCelularesText, '6 5 Posee una bateria de 4000mh');
  writeln (archivoCelularesText, 'YY6');
  writeln (archivoCelularesText, '88783 69827 NOKIA');
  writeln (archivoCelularesText, '10 3 Color negro mate');
  writeln (archivoCelularesText, 'UUH');
  close (archivoCelularesText);	
  leerFichero (archivoCelularesText);
END.

