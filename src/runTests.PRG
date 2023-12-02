clear
LOCAL err as Exception

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