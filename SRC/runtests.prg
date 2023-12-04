CLEAR
CLOSE TABLES all
LOCAL err as Exception
* --------------------------------------
? "Tests ItemArticulo: "
success = .f.
TRY 
	test01ArticuloSeCreaInvalido()
	test02ArticuloInicializadoConCamposValidosEsValido()
	test03ArticuloInicializadoConItemsInvalidosEsInvalido()
	test04MontoCalculadoEnBaseALosDemasCampos()
	
	success = .t.
CATCH TO err 
	? err.UserValue
	? err.Message
ENDTRY 

IF success
	?? "OK"
ENDIF 
* --------------------------------------
? "Tests Factura: "
success = .f.
TRY 
	test05AñadirArticuloInvalidoAFacturaDebeLanzarExcepcion()
	test06TotalDeLaFacturaEsLaSumaDelMontoDeLosArticulos()
	test07DarDeAltaUnaFacturaConCamposInvalidosDebeLanzarExcepcion()
	test08EliminarUnaFacturaConPuntoDeVentaLetraONumeroInvalidosDebeLanzarExcepcion()
	test09DarDeAltaUnaFacturaQueYaExisteLanzaExcepcion()
	test10EliminarUnaFacturaQueNoExisteLanzaExcepcion()
	
	success = .t.
CATCH TO err 
	? err.UserValue
	? err.Message
ENDTRY 

IF success
	?? "OK"
ENDIF 

* ------------------- Tests -------------------
PROCEDURE test01ArticuloSeCreaInvalido()
	itemArt = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
	IF itemArt.itemValido()
		THROW "[test01] Articulo sin inicializar debe ser invalido"
	ENDIF 
ENDPROC 

PROCEDURE test02ArticuloInicializadoConCamposValidosEsValido()
	itemArt = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
	itemArt.inicializar("art01", "articulo 01", 10, 100, 21)
	
	IF NOT itemArt.itemValido()
		THROW "[test02] Articulo inicializado con campos validos debe ser valido"
	ENDIF 
ENDPROC 

PROCEDURE test03ArticuloInicializadoConItemsInvalidosEsInvalido()
	itemArt1 = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
	itemArt2 = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
	itemArt2bis = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
	itemArt3 = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
	itemArt4 = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
	itemArt5 = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
	
	codigoInvalido=""
	cantidadInvalida=-6
	cantidadNula=0
	precioInvalido=-2
	alicuotaInvalida=-89
	
	itemArt1.inicializar(codigoInvalido, "articulo 01", 10, 100, 21)
	itemArt2.inicializar("art01", "articulo 01", cantidadInvalida, 100, 21)
	itemArt2bis.inicializar("art01", "articulo 01", cantidadNula, 100, 21)
	itemArt3.inicializar("art01", "articulo 01", 10, precioInvalido, 21)
	itemArt4.inicializar("art01", "articulo 01", 10, 100, alicuotaInvalida)
	
	IF itemArt1.itemValido() OR ;
		itemArt2.itemValido() OR ;
		itemArt2bis.itemValido() OR ;
		itemArt3.itemValido() OR ;
		itemArt4.itemValido()
		
		THROW "[test03] Todos los campos deben ser válidos para que en articulo sea valido"
	ENDIF 
ENDPROC 

PROCEDURE test04MontoCalculadoEnBaseALosDemasCampos()
	itemArt = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
	
	cantidad = 10
	precioUnitario = 100
	alicuotaIVA = 21
	
	itemArt.inicializar("art01", "articulo 01", cantidad , precioUnitario , alicuotaIVA)
	montoEsperado = cantidad * precioUnitario * (1 + alicuotaIVA/100)
	
	IF itemArt.monto != montoEsperado
		THROW "[test04] Calculo de monto incorrecto"
	ENDIF 
ENDPROC 

PROCEDURE test05AñadirArticuloInvalidoAFacturaDebeLanzarExcepcion()
	LOCAL err as Exception 
	factura = NEWOBJECT("Factura", "factura.prg")
	itemArt = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
	
	cantidadInvalida = -2
	itemArt.inicializar("art01", "articulo 01", cantidadInvalida, 100, 21)

	errorLanzado = .f.
	TRY
		factura.agregarArticulo(itemArt)
	CATCH TO err
		errorLanzado = .t.	
	ENDTRY 
	
	IF NOT errorLanzado
		THROW "[test05] debe lanzarse error al agregar articulos invalidos"
	ENDIF 
ENDPROC 

PROCEDURE test06TotalDeLaFacturaEsLaSumaDelMontoDeLosArticulos()
	factura = NEWOBJECT("Factura", "factura.prg")
	itemArt1 = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
	itemArt2 = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
	itemArt3 = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
	
	precioUnitario1=5
	precioUnitario2=7
	precioUnitario3=8
	cantidad=10
	alicuotaIVA=21
	
	itemArt1.inicializar("art01", "articulo 01", cantidad, precioUnitario1, alicuotaIVA)
	itemArt2.inicializar("art02", "articulo 02", cantidad, precioUnitario1, alicuotaIVA)
	itemArt3.inicializar("art03", "articulo 03", cantidad, precioUnitario1, alicuotaIVA)
	
	factura.agregarArticulo(itemArt1)
	factura.agregarArticulo(itemArt2)
	factura.agregarArticulo(itemArt3)

	totalEsperado = itemArt1.monto + itemArt2.monto + itemArt3.monto

	IF factura.total != totalEsperado
		THROW "[test06] El total de la factura debe ser la suma de los montos de cada articulo"
	ENDIF 
ENDPROC 

PROCEDURE test07DarDeAltaUnaFacturaConCamposInvalidosDebeLanzarExcepcion()
	private factura1 as Object, factura2 as Object, factura3 as Object, factura4 as Object
	
	factura1 = NEWOBJECT("Factura", "factura.prg")
	factura2 = NEWOBJECT("Factura", "factura.prg")
	factura3 = NEWOBJECT("Factura", "factura.prg")
	factura4 = NEWOBJECT("Factura", "factura.prg")
	
	itemArt = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
	itemArt.inicializar("art01", "articulo 01", 10, 100, 21)
	
	puntoVentaInvalido = -1
	letraInvalida = 'X'
	numeroInvalido = -1
	fechaInvalida = {}
	
	factura1.puntoVenta = puntoVentaInvalido 
	factura1.letra = 'A'
	factura1.numero = 2300000
	factura1.fecha = CTOD("22/06/1995")
	factura1.agregarArticulo(itemArt)
	
	
	factura2.puntoVenta = 1
	factura2.letra = letraInvalida 
	factura2.numero = 2300000
	factura2.fecha = CTOD("22/06/1995")
	factura2.agregarArticulo(itemArt)
	
	
	factura3.puntoVenta = 1
	factura3.letra = 'A'
	factura3.numero = numeroInvalido 
	factura3.fecha = CTOD("22/06/1995")
	factura3.agregarArticulo(itemArt)
	
	
	factura4.puntoVenta = 1
	factura4.letra = 'A'
	factura4.numero = 2300000
	factura4.fecha = fechaInvalida 
	factura4.agregarArticulo(itemArt)

	todasLasExcepcionesLanzadas = ;
		instruccionLanzaExcepcion("factura1.darAlta()") and ;
		instruccionLanzaExcepcion("factura2.darAlta()") and ;
		instruccionLanzaExcepcion("factura3.darAlta()") and ;
		instruccionLanzaExcepcion("factura4.darAlta()")
	
	IF NOT todasLasExcepcionesLanzadas
		THROW "[test07] No se puede dar de alta una factura invalida"
	ENDIF 
ENDPROC 

FUNCTION instruccionLanzaExcepcion(macroInstruccion as Character) as boolean
	excepcionLanzada = .t.
	try
		&macroInstruccion
		excepcionLanzada = .f.
	CATCH
		excepcionLanzada = .t.
	ENDTRY 
	RETURN excepcionLanzada
ENDPROC 

PROCEDURE test08EliminarUnaFacturaConPuntoDeVentaLetraONumeroInvalidosDebeLanzarExcepcion()
	factura1 = NEWOBJECT("Factura", "factura.prg")
	factura2 = NEWOBJECT("Factura", "factura.prg")
	factura3 = NEWOBJECT("Factura", "factura.prg")
	
	puntoVentaInvalido = -1
	letraInvalida = 'X'
	numeroInvalido = -1
	
	factura1.puntoVenta = puntoVentaInvalido 
	factura1.letra = 'A'
	factura1.numero = 2300000
	
	factura2.puntoVenta = 1
	factura2.letra = letraInvalida
	factura2.numero = 2300000
	
	factura3.puntoVenta = 1
	factura3.letra = 'A'
	factura3.numero = numeroInvalido
	
	todasLasExcepcionesLanzadas = ;
		instruccionLanzaExcepcion("factura1.eliminar()") and ;
		instruccionLanzaExcepcion("factura2.eliminar()") and ;
		instruccionLanzaExcepcion("factura3.eliminar()")
		
	IF NOT todasLasExcepcionesLanzadas
		THROW "[test08] eliminar una factura con punto de venta, letra o numero invalidos debe lanzar excepcion"
	ENDIF 
ENDPROC 


PROCEDURE test09DarDeAltaUnaFacturaQueYaExisteLanzaExcepcion()
	factura= NEWOBJECT("Factura", "factura.prg")

	itemArt1 = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
	itemArt2 = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
	itemArt1.inicializar("art01", "articulo 01", 10, 100, 21)
	itemArt2.inicializar("art02", "articulo 02", 10, 100, 21)

	factura.puntoVenta = 1
	factura.letra = 'A'
	factura.numero = 8
	factura.fecha = CTOD("22/06/1995")
	factura.agregarArticulo(itemArt1)
	factura.agregarArticulo(itemArt2)
	
	excepcionLanzada = .f.
	TRY 
		&& podria lanzarse expcecion en el primer llamado si la factura ya existe en la tabla
		factura.darAlta()
		factura.darAlta()
	CATCH TO err
		factura.eliminar()
		excepcionLanzada = .t.
	ENDTRY
	
	IF !excepcionLanzada 
		THROW "[test09] dar de alta una factura ya existente debe lanzar excepcion"
	ENDIF 
ENDPROC

PROCEDURE test10EliminarUnaFacturaQueNoExisteLanzaExcepcion()
	factura= NEWOBJECT("Factura", "factura.prg")

	itemArt1 = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
	itemArt2 = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
	itemArt1.inicializar("art01", "articulo 01", 10, 100, 21)
	itemArt2.inicializar("art02", "articulo 02", 10, 100, 21)

	factura.puntoVenta = 1
	factura.letra = 'A'
	factura.numero = 8
	factura.fecha = CTOD("22/06/1995")
	factura.agregarArticulo(itemArt1)
	factura.agregarArticulo(itemArt2)
	
	excepcionLanzada= .f.
	TRY 
		&& podria lanzarse expcecion en el primer llamado si la factura ya existe en la tabla
		factura.eliminar()
		
		factura.darAlta()
		factura.eliminar()
	CATCH TO err
		excepcionLanzada = .t.
	ENDTRY
	
	IF !excepcionLanzada
		THROW "[test10] eliminar una factura no existente debe lanzar excepcion"
	ENDIF 
ENDPROC
