#define RUTA_FAC "fac.dbf"
#define RUTA_FACDET "facdet.dbf"

#define PERMITE_DUPLICADOS as .t.

PROCEDURE darAlta(factura as Object)
	verificarTablas()
	commitFac(factura)
	commitFacDet(factura)
ENDFUNC 

PROCEDURE eliminar(factura as Object)
	? "TODO: [eliminar]"
ENDPROC 

&& ----------------------------------------	
&& Verifica que existan las tablas. De fallar la 
&& verificacion se crearan en blanco.
&& ----------------------------------------
PROCEDURE verificarTablas()
	IF !FILE(RUTA_FAC) OR !FILE(RUTA_FACDET)
		CREATE TABLE FAC ( ;
			fptoven numeric(5), ;
			fletra character(1), ;
			fnumcomp numeric(8), ;
			ffecha date, ;
			fcodcli character(15), ;
			ftotal numeric(15,2) ;
		)

		CREATE TABLE FACDET ( ;
			fptoven numeric(5), ;
			fletra character(1), ;
			fnumcomp numeric(8), ;
			fcodart character(10), ;
			fdesart character(25), ;
			fcant numeric(15,2), ;
			fprecuni numeric(15,2), ;
			faliciva numeric(5,2), ;
			fmonto numeric(15,2) ;
		)

		USE IN ("FAC")
		USE IN ("FACDET")
	ENDIF
ENDPROC 

PROCEDURE commitFac(factura as Object)
	TRY 
		USE RUTA_FAC IN 0 ALIAS "facTable" EXCLUSIVE
		SELECT facTable
		APPEND BLANK
		replace ;
				fptoven WITH factura.puntoVenta, ;
				fletra WITH factura.letra, ;
				fnumcomp WITH factura.numero, ;
				ffecha WITH factura.fecha, ;
				fcodcli WITH factura.codigoCliente, ; 
				ftotal WITH factura.total
	FINALLY 
		USE IN ("facTable")
	ENDTRY 
ENDPROC 

PROCEDURE commitFacDet(factura as Object)
	detalleArticulos = factura.detalleArticulos 
	TRY 
		USE RUTA_FACDET IN 0 ALIAS "facDetTable" EXCLUSIVE
		SELECT facDetTable
		FOR EACH articulo IN detalleArticulos
			APPEND BLANK
			replace ;
					fptoven WITH factura.puntoVenta, ;
					fletra WITH factura.letra, ;
					fnumcomp WITH factura.numero, ;
					fcodart WITH articulo.codigoArticulo, ;
					fdesart WITH articulo.descripcionArticulo, ;
					fcant WITH articulo.cantidad, ;
					fprecuni WITH articulo.precioUnitario, ;
					faliciva WITH articulo.alicuotaIVA, ;
					fmonto WITH articulo.monto
		ENDFOR
	FINALLY 
		USE IN ("facDetTable")
	ENDTRY 
ENDPROC 