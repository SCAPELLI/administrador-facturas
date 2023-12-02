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

	FUNCTION agregarArticulo(itemArt as ItemArticulo) as VOID
		this.lanzarExcepcionSiMontoInvalido(itemArt)
		this.lanzarExcepcionSiItemInvalido(itemArt)
		this.detalleArticulos.add(itemArt)
	ENDFUNC
	
	FUNCTION darAlta() as VOID
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
		* logica de alta
		*TODO: Si todo sale bien se cargarán en los dbfs que correspondan los registros con los datos de la factura.
	ENDFUNC
	FUNCTION eliminar() as VOID
	ENDFUNC
	
	* -------------------
	
	HIDDEN FUNCTION lanzarExcepcionSiMontoInvalido(itemArt as itemArticulo)
		IF NOT itemArt.monto >= 0
			THROW "El monto no puede ser negativo"
		ENDIF
	ENDFUNC

	*puntoVenta = 0
	*letra = ""
	*numero = 0
	*fecha = {}
	*codigoCliente = ""

	HIDDEN FUNCTION lanzarExcepcionSiItemInvalido(itemArt as itemArticulo)
		IF NOT itemArt.itemValido()
			THROW "Item invalido"
		ENDIF
	ENDFUNC
	
	HIDDEN FUNCTION ptoVentaValido(log as Character) as Boolean
		valido = this.puntoVenta >= 0
		IF NOT valido
			log = log + "punto de venta negativo; "
		ENDIF
		RETURN valido
	ENDFUNC 
	
	HIDDEN FUNCTION letraValida(log as Character) as Boolean
		valido = INLIST(this.letra, "A","B","C","D")
		IF NOT valido
			log = log + "letra debe valer A,B,C o D; "
		ENDIF
		RETURN valido
	ENDFUNC
	
	HIDDEN FUNCTION numeroValido(log as Character) as Boolean
		valido = this.numero > 0
		IF NOT valido
			log = log + "numero debe ser positivo; "
		ENDIF
		RETURN valido
	ENDFUNC
	
	HIDDEN FUNCTION fechaValida(log as Character) as Boolean
		valido =  not EMPTY(this.fecha)
		IF NOT valido
			log = log + "fecha no puede estar vacia; "
		ENDIF
		RETURN valido
		
	ENDFUNC
	
	HIDDEN FUNCTION detalleArticuloValido(log as Character) as Boolean
		&& Condicion de coleccion no vacia
		&& --------------------
		coleccionVacia = this.detalleArticulos.count = 0
		IF coleccionVacia
			log = log + "se debe incluir al menos un articulo; "
			RETURN .f.
		ENDIF
		&& --------------------
		
		&& Condicion de elementos validos
		&& --------------------
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
		&& --------------------
		
		RETURN .t.
	ENDFUNC
	
	HIDDEN FUNCTION totalValido(log as Character) as Boolean
		valido = this.calcularTotalFactura() >= 0
		IF NOT valido
			log = log + "el total de la factura es negativo;"
		ENDIF
		RETURN valido
	ENDFUNC
	
	HIDDEN FUNCTION calcularTotalFactura() as double
		totalFactura = 0
		FOR EACH articulo IN this.detalleArticulos
			totalFactura = totalFactura + articulo.monto
		ENDFOR
		RETURN totalFactura
	ENDFUNC
	
ENDDEFINE