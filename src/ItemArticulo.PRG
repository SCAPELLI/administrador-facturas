DEFINE CLASS ItemArticulo as Custom
	codigoArticulo = ""
	descripcionArticulo = ""
	cantidad = 0.0
	precioUnitario = 0.0
	alicuotaIVA = 0.0
	monto = 0.0
	
	&& ----------------------------------------	
	&& Se verifican las condiciones de item válido
	&& ----------------------------------------	
	FUNCTION itemValido() as Boolean
		RETURN ( ;
			not EMPTY(this.codigoArticulo) AND ;
			this.cantidad > 0 AND ;
			this.precioUnitario >= 0 AND ;
			this.alicuotaIVA >= 0 AND ;
			this.monto_access() >= 0 ;
		)
	ENDFUNC


	&& ----------------------------------------	
	&& Se calcula el monto del articulo
	&& ante el evento de acceso al atributo 'monto'
	&& ----------------------------------------	
	FUNCTION monto_access() as double
		RETURN this.cantidad * this.precioUnitario * (1 + this.alicuotaIVA/100)
	ENDFUNC

	&& ----------------------------------------	
	&& Carga del conjunto de valores de una instancia
	&& Obs: El monto se calcula en base al resto de valores ingresados
	&& ----------------------------------------	
	FUNCTION inicializar( ;
		codigoArticulo as character, ;
		descripcionArticulo as character, ;
		cantidad as double, ;
		precioUnitario as double, ;
		alicuotaIVA as double ;
	) as VOID
		WITH this
			.codigoArticulo = codigoArticulo 
			.descripcionArticulo = descripcionArticulo 
			.cantidad = cantidad 
			.precioUnitario = precioUnitario 
			.alicuotaIVA = alicuotaIVA
			.monto = .monto_access()
		endwith
	ENDFUNC 

ENDDEFINE