clear
factura = NEWOBJECT("Factura", "factura.prg")

itemArt1 = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
itemArt2 = NEWOBJECT("ItemArticulo", "ItemArticulo.prg")
itemArt1.inicializar("art01", "articulo 01", 10, 100, 21)
itemArt2.inicializar("art02", "articulo 02", 10, 100, 21)

factura.puntoVenta = 1
factura.letra = 'A'
factura.numero = 2300000
factura.fecha = CTOD("22/06/1995")
factura.agregarArticulo(itemArt1)
factura.agregarArticulo(itemArt2)

factura.darAlta()
factura.eliminar()