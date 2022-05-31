{
   
}


program ejer14prac2;
type
  reg_vuelo = record
    destino: string;
    fecha: longInt;    //20220812
    hora_salida: real; //23.30
    cant_asientos: integer;
  end;
  
  archivoVuelos = file of reg_vuelo;

procedure crearArchivo ():

  
var
  arch_maestro: archivoVuelos;
  arch_detalle_1, arch_detalle_2: archivoVuelos;
  opc: integer;

BEGIN
  assign (arch_maestro, 'archivo_vuelos');
  assign (arch_detalle_1, 'archivo_ventas_vuelo_1');
  assign (arch_detalle_2, 'archivo_ventas_vuelo_2');
  opc := menuOpciones ();
  
  case opc of
    1: crearArchivoMaestro (arch_maestro); //se dispone
    2: crearArchivoDetalle (arch_detalle1, archivo_detalle_2); //se dispone
    3: actualizarMaestro (arch_maestro, arch_detalle_1, arch_detalle_2);
    4: listaVuelos (arch_maestro); // ANTES DE ESTO SE DEBE EJECUTAR ACTUALIZARMAESTRO... EN EL EXAMEN ESTARIA BUENO HACERLO ASI? 
                                   // O DEBERIA TENER UNA VARIABLE GLOBAL PARA QUE NO SE VUELVA A ACTUALIZAR EL MAESTRO O SE ACTUALIZE 
                                   // SI ES QUE NO SE ACTUALIZO? 
  end;
  
END.

