clear
*SET STEP on
LOCAL factura as Object, itemArt as Object, err as Exception
factura = NEWOBJECT("Factura", "factura.prg")


factura.puntoVenta = 1
factura.letra = 'A'
factura.numero = 2300000
factura.fecha = CTOD("22/06/1995")

itemArt = NEWOBJECT("ItemArticulo", "itemarticulo.prg")
itemArt.inicializar("art01", "articulo 01", 10, 100, 21)

itemArt2 = NEWOBJECT("ItemArticulo", "itemarticulo.prg")
itemArt2.inicializar("art01", "articulo 01", 10, 100, 21)

TRY 
	factura.agregarArticulo(itemArt)
	factura.agregarArticulo(itemArt2)
	printState(factura)
CATCH TO err
	? err.userValue
ENDTRY

* --------------------------

PROCEDURE printState(factura as Object)
	? "------------------"
	? "total: " + transform(factura.total)
	? "puntoVenta: " + transform(factura.puntoVenta )
	? "letra: " + transform(factura.letra)
	? "numero: " + transform(factura.numero)
	? "fecha: " + transform(factura.fecha)
	? "detalleArticulos type: " + transform(TYPE("factura.detalleArticulos"))
	TRY
		factura.darAlta()
		? "Alta OK"
	CATCH TO err
		? "darAlta() ERROR: " + TRANSFORM(err.UserValue)
	ENDTRY
	? "------------------"
ENDPROC
