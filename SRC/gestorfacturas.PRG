#define DIRECTORIO_DBF "..\DBF\"
#define DIRECTORIO_IDX "..\IDX\"
#define DIRECTORIO_SRC "..\SRC"

#define NOMBRE_FAC "fac.dbf"
#define RUTA_FAC (DIRECTORIO_DBF + NOMBRE_FAC)

#define NOMBRE_FACDET "facdet.dbf"
#define RUTA_FACDET(DIRECTORIO_DBF + NOMBRE_FACDET)

#define NOMBRE_IDX "fac.idx"
#define RUTA_INDICE_FAC (DIRECTORIO_IDX + NOMBRE_IDX)

&& ------------------- Funciones publicas ---------------------	

&& ----------------------------------------	
&& Se verifica que existan las tablas y en ese caso se generan 
&& los registros asociados a la factura
&& ----------------------------------------
PROCEDURE darAlta(factura as Object)
	verificarTablas()
	commitFac(factura)
	commitFacDet(factura)
ENDFUNC 


&& ----------------------------------------	
&& Se verifica que existan las tablas y en ese caso se eliminan todos 
&& los registros asociados a la factura
&& ----------------------------------------
PROCEDURE eliminar(factura as Object)
	verificarTablas(.t.)
	eliminarDeFacDet(factura)
	eliminarDeFac(factura)
ENDPROC 

&& ------------------- Funciones privadas ---------------------	

&& ----------------------------------------	
&& Busqueda por tupla: (punto de venta, letra, numero)
&& retorna un booleano indicando si se encontro.
&& En caso de encontrarse: el cursor se posiciona en alguno de los registros coincidentes
&& ----------------------------------------
FUNCTION buscarRegistro(factura as Object) as Boolean
	* ERROR: 'set order to RUTA_INDICE_FAC' o 'set order to fac' da error.
	* Como alternativa, elimino el indice y lo vuelvo a crear en cada busqueda 
	* -----------------

	IF FILE(RUTA_INDICE_FAC)
		DELETE FILE RUTA_INDICE_FAC
	ENDIF
	
	cd DIRECTORIO_IDX 
	INDEX ON STR(fptoven) + fletra + STR(fnumcomp) TO fac
	CD DIRECTORIO_SRC
	* -----------------
	
	SEEK STR(factura.puntoVenta) + factura.letra + STR(factura.numero)

	CLOSE INDEXES
	
	
	RETURN FOUND()
ENDPROC 

&& ----------------------------------------	
&& Verifica que existan las tablas. De fallar la verificacion se crearan en blanco.
&& ----------------------------------------
PROCEDURE verificarTablas(lanzarExcepcionSiFaltanTablas as Boolean)
	IF !FILE(RUTA_FAC) OR !FILE(RUTA_FACDET)
		IF lanzarExcepcionSiFaltanTablas
			THROW "Operacion cancelada: Faltan tablas"
		ENDIF
		
		CD DIRECTORIO_DBF 
		
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
		
		CD DIRECTORIO_SRC

		USE IN ("FAC")
		USE IN ("FACDET")
	ENDIF
ENDPROC 

&& ----------------------------------------	
&& Se carga un nuevo registro en la tabla de facturas
&& ----------------------------------------
PROCEDURE commitFac(factura as Object)
	registroEncontrado = .t.
	TRY 
		USE RUTA_FAC IN 0 ALIAS "facTable" EXCLUSIVE
		SELECT facTable
		registroEncontrado = buscarRegistro(factura)
		IF !registroEncontrado
			APPEND BLANK
			replace ;
					fptoven WITH factura.puntoVenta, ;
					fletra WITH factura.letra, ;
					fnumcomp WITH factura.numero, ;
					ffecha WITH factura.fecha, ;
					fcodcli WITH factura.codigoCliente, ; 
					ftotal WITH factura.total
		ENDIF 
	FINALLY 
		USE IN ("facTable")
	ENDTRY 
	IF registroEncontrado 
		THROW "No se puede dar de alta una factura que ya existe"
	ENDIF
ENDPROC 

&& ----------------------------------------	
&& Por cada articulo de la factura se carga un registro en la tabla de detalles factura
&& ----------------------------------------
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

&& ----------------------------------------	
&& Se elimina el registro de la tabla de facturas
&& ----------------------------------------
PROCEDURE eliminarDeFac(factura as Object)
	registroEncontrado = .t.
	TRY 
		USE RUTA_FAC IN 0 ALIAS "facTable" EXCLUSIVE
		SELECT facTable
		
		registroEncontrado = buscarRegistro(factura)
		IF registroEncontrado 
			DELETE
			PACK
		ENDIF 
	FINALLY
		USE IN ("facTable")
	ENDTRY
	
	IF !registroEncontrado 
		THROW "No se puede eliminar una factura que no existe"
	ENDIF 
ENDPROC 

&& ----------------------------------------	
&& Se eliminan todos los registros asociados de la tabla de detalles de factura
&& ----------------------------------------
PROCEDURE eliminarDeFacDet(factura as Object)
	TRY 
		USE RUTA_FACDET IN 0 ALIAS "facDetTable" EXCLUSIVE
		SELECT facDetTable
		registroEncontrado = .t.
		DO WHILE registroEncontrado
			registroEncontrado = buscarRegistro(factura)
			IF registroEncontrado 
				DELETE
				PACK
			ENDIF
		ENDDO
	FINALLY 
		USE IN ("facDetTable")
	ENDTRY
ENDPROC 