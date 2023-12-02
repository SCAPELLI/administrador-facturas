itemArt = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
? "item valido: " + transform(itemArt.itemValido())
TRY 
	factura.agregarArticulo(itemArt)
CATCH TO err
	? err.UserValue
ENDTRY
itemArt.inicializar("art01", "articulo 01", 10, 100, 21)
? "item valido: " + transform(itemArt.itemValido())
? itemArt.monto
TRY 
	factura.agregarArticulo(itemArt)
CATCH TO err
	? err.UserValue
ENDTRY


