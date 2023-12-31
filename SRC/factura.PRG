DEFINE CLASS Factura as Custom
	puntoVenta = -1
	letra = ""
	numero = 0
	fecha = {}
	codigoCliente = ""
	detalleArticulos = null
	total = 0.0
	
	FUNCTION init() as void
		this.detalleArticulos = NEWOBJECT("Collection")
	ENDFUNC 

	* --------------------------------------  M�todos P�blicos -------------------------------------- 
	
	&& ----------------------------------------	
	&& Validacion y agregado de articulo a la factura
	&& ----------------------------------------	
	FUNCTION agregarArticulo(itemArt as ItemArticulo) as VOID
		&& validaciones
		this.lanzarExcepcionSiMontoInvalido(itemArt)
		this.lanzarExcepcionSiItemInvalido(itemArt)
		
		&& se agrega el articulo a la factura
		this.detalleArticulos.add(itemArt)
		this.total = this.total + itemArt.monto
	ENDFUNC
	
	
	&& ----------------------------------------	
	&& Validacion de campos en factura
	&& y registro de la factura en tablas
	&& ----------------------------------------	
	FUNCTION darAlta() as VOID
		this.lanzarExcepcionConAltaInvalida()
		DO darAlta WITH this IN gestorFacturas.prg
	ENDFUNC
	
	
	&& ----------------------------------------	
	&& Validacion de campos punto de venta, letra y numero
	&& y eliminacion de factura en tablas
	&& ----------------------------------------	
	FUNCTION eliminar() as VOID
		this.lanzarExcepcionSiEliminacionInvalida()
		DO eliminar WITH this IN gestorFacturas.prg
	ENDFUNC
	
	&& ----------------------------------------	
	&& Se calcula el total de la factura 
	&& ante el evento de acceso al atributo 'total'
	&& ----------------------------------------	
	FUNCTION total_access() as Double
		totalAcumulado = 0
		FOR EACH articulo IN this.detalleArticulos
			totalAcumulado = totalAcumulado + articulo.monto
		ENDFOR
		RETURN totalAcumulado
	ENDFUNC 
	
	* -------------------------------------- M�todos Privados -------------------------------------- 

	&& ----------------------------------------	
	&& En caso de no cumplir las condiciones se lanza una excepci�n
	&& ----------------------------------------	
	HIDDEN FUNCTION lanzarExcepcionSiMontoInvalido(itemArt as itemArticulo) as VOID 
		IF NOT itemArt.monto >= 0
			THROW "No se puede almacenar un item con monto negativo"
		ENDIF
	ENDFUNC

	HIDDEN FUNCTION lanzarExcepcionSiItemInvalido(itemArt as itemArticulo) as VOID 
		IF NOT itemArt.itemValido()
			THROW "No se puede almacenar un item invalido"
		ENDIF
	ENDFUNC
	
	HIDDEN FUNCTION lanzarExcepcionConAltaInvalida() as VOID 
		errorLog = ""
		WITH this
			.ptoVentaValido(@errorLog)
			.letraValida(@errorLog)
			.numeroValido(@errorLog)
			.fechaValida(@errorLog)
			.detalleArticuloValido(@errorLog)
			.totalValido(@errorLog)
		ENDWITH
		
		altaValida = EMPTY(errorLog)
		IF NOT altaValida
			THROW "Alta invalida: " + errorLog
		ENDIF
	ENDFUNC
	
	HIDDEN FUNCTION lanzarExcepcionSiEliminacionInvalida() as VOID
		errorLog = ""
		WITH this
			.ptoVentaValido(@errorLog)
			.letraValida(@errorLog)
			.numeroValido(@errorLog)
		ENDWITH
		
		eliminacionValida = EMPTY(errorLog)
		IF NOT eliminacionValida 
			THROW "Eliminaci�n invalida: " + errorLog
		ENDIF
	ENDFUNC
	&& ----------------------------------------

	
	&& ----------------------------------------
	&& Verifica que el punto de venta sea no negativo
	&& ----------------------------------------
	HIDDEN FUNCTION ptoVentaValido(log as Character) as Boolean
		valido = this.puntoVenta >= 0
		IF NOT valido
			log = log + "punto de venta negativo; "
		ENDIF
		RETURN valido
	ENDFUNC 
	
	
	&& ----------------------------------------
	&& Verifica que el campo letra pertenezca al conjunto de letras validas
	&& ----------------------------------------
	HIDDEN FUNCTION letraValida(log as Character) as Boolean
		valido = INLIST(this.letra, "A","B","C","D")
		IF NOT valido
			log = log + "letra debe valer A,B,C o D; "
		ENDIF
		RETURN valido
	ENDFUNC
	
	
	&& ----------------------------------------
	&& Verifica que el campo numero sea positivo
	&& ----------------------------------------
	HIDDEN FUNCTION numeroValido(log as Character) as Boolean
		valido = this.numero > 0
		IF NOT valido
			log = log + "numero debe ser positivo; "
		ENDIF
		RETURN valido
	ENDFUNC
	
	
	&& ----------------------------------------
	&& Verifica fecha no vacia
	&& ----------------------------------------
	HIDDEN FUNCTION fechaValida(log as Character) as Boolean
		valido =  not EMPTY(this.fecha)
		IF NOT valido
			log = log + "fecha no puede estar vacia; "
		ENDIF
		RETURN valido
		
	ENDFUNC
	
	&& ----------------------------------------
	&& se verifica que haya articulos y que todos sean validos
	&& ----------------------------------------
	HIDDEN FUNCTION detalleArticuloValido(log as Character) as Boolean
		&& Condicion de coleccion no vacia
		coleccionVacia = this.detalleArticulos.count = 0
		IF coleccionVacia
			log = log + "se debe incluir al menos un articulo; "
			RETURN .f.
		ENDIF
		
		&& Condicion de elementos validos
		articulosValidos = .t.
		FOR EACH articulo IN this.detalleArticulos
			IF NOT articulo.itemValido()
				articulosValidos = .f.
				exit
			endif
		endfor
		IF NOT articulosValidos 
			log = log + "existen articulos invalidos; "
			RETURN .f.
		ENDIF
				
		RETURN .t.
	ENDFUNC
	
	&& ----------------------------------------
	&& se verifica que el total de factura sea no negativo
	&& ----------------------------------------
	HIDDEN FUNCTION totalValido(log as Character) as Boolean
		valido = this.calcularTotalFactura() >= 0
		IF NOT valido
			log = log + "el total de la factura es negativo;"
		ENDIF
		RETURN valido
	ENDFUNC
	
	&& ----------------------------------------
	&& Calculo de total de factura en base a los 
	&& montos de cada articulo
	&& ----------------------------------------
	HIDDEN FUNCTION calcularTotalFactura() as double
		totalFactura = 0
		FOR EACH articulo IN this.detalleArticulos
			totalFactura = totalFactura + articulo.monto
		ENDFOR
		RETURN totalFactura
	ENDFUNC
ENDDEFINE