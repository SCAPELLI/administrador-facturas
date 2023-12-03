CLEAR
LOCAL err as Exception 

factura= NEWOBJECT("Factura", "factura.prg")

itemArt1 = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
itemArt2 = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
itemArt1.inicializar("art01", "articulo 01", 10, 100, 21)
itemArt2.inicializar("art02", "articulo 02", 10, 100, 21)

factura.puntoVenta = 1
factura.letra = 'C'
factura.numero = 7
factura.fecha = CTOD("22/06/1995")
factura.agregarArticulo(itemArt1)
factura.agregarArticulo(itemArt2)



TRY 
	factura.darAlta()
	factura.darAlta()
CATCH TO err
	? err.UserValue
ENDTRY

TRY
	factura.eliminar()
	factura.eliminar()
CATCH TO err
	? err.UserValue
	? err.Message
ENDTRY