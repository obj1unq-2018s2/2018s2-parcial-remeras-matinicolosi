class ValorRemera {
	var property remeraChica = 80
	var property remeraGrande = 100
}

class RemeraLisa {
	const property talle = 0 // del 32 al 48.
	const property color = "Roja"
	const property preciosActuales = null // de tipo ValorRemera
	method precioSegunTalle () {
		return if (talle < 41) preciosActuales.remeraChica()
		else preciosActuales.remeraGrande()
	}
	method esDeColorBasico () {
		return color == "Negro" or color == "Gris" or color == "Blanco"
	}
	method precio () {
		return if (self.esDeColorBasico ()) self.precioSegunTalle ()
		else self.precioSegunTalle () + self.precioSegunTalle () * 0.10
	}
	method porcentajeDeDescuento () {
		return 10
	}
}

class RemeraBordada inherits RemeraLisa {
	const property cantColores = 0 // numero.
	method precioBordado () {
		return if (cantColores < 2) 20
		else cantColores * 10
	}
	override method precio () {
		return super () + self.precioBordado ()
	}
	override method porcentajeDeDescuento () {
		return 2
	}
}

class RemeraSublimada inherits RemeraLisa {
	const property anchoDelDibujo = 0 // numero.
	const property altoDelDibujo = 0 // numero.
	method superficie () {
		return altoDelDibujo * anchoDelDibujo
	}
	override method precio () {
		return super () + self.superficie () * 0.5
	}
}

class RemeraSublimadaConDibujoPrivado inherits RemeraSublimada {
	const property empresa = null
	override method precio () {
		return super () + empresa.precioDerechosDibujo ()
	}
	override method porcentajeDeDescuento () {
		return if (empresa.tieneConvenio ()) 20
		else 10
	}
}

class Empresa {
	var property precioDerechosDibujo = 100 // numero.
	var property tieneConvenio = true // booleano.
}

class Comercio {
	var property sucursales = [] // lista de sucursales.
	var property registroDePedidos = [] // lista de pedidos.
	method registrarPedido (pedido) {
		registroDePedidos.add(pedido)
	}
	method totalFacturado () {
		return registroDePedidos.sum{pedido => pedido.precioFinal ()}
	}
	method totalFacturadoPor (sucursal) {
		return registroDePedidos.filter{pedido => pedido.sucursal() == sucursal}.sum{pedido => pedido.precioFinal ()}
	}
	method cantPedidosDeRemeraDeColor (color) {
		return registroDePedidos.filter{pedido => pedido.remera().color() == color}.size()
	}
	method pedidoMasCaro () {
		return registroDePedidos.max{pedido => pedido.precioFinal ()}
	}
	method tallesSinPedido () {
		const talles = new Range (32, 48)
		talles.filter{talle => not registroDePedidos.any{pedido => pedido.talle() == talle} }
	}
	method sucursalQueMasFacturo () {
		return sucursales.max{sucursal => self.totalFacturadoPor (sucursal)}
	}
	method sucursalesQueVendieronTodosLosTalles () {
		const talles = new Range (32, 48)
		return sucursales.filter{sucursal => talles.all{talle => self.pedidosDeSurcursal(sucursal).any{pedido => pedido.remera().talle() == talle}}}
	}
	method pedidosDeSurcursal (sucursal) {
		return registroDePedidos.filter{pedido => pedido.sucursal() == sucursal}
	}
	
}

class Sucursal {
	var property pedidos = [] // lista de Pedidos.
	const property cantRemerasMinParaDescuento = 10 // numero.
}

class Pedido {
	const property remera = null // modelo remera.
	const property cantidad = 10 // numero.
	var property sucursal = null
	method precioBase () {
		return remera.precio() * cantidad
	}
	method aplicaDescuento () {
		return cantidad >= sucursal.cantRemerasMinParaDescuento ()
	}
	method precioFinal () {
		return if (not self.aplicaDescuento ()) self.precioBase ()
		else self.precioBase () - (self.precioBase () * (remera.porcentajeDeDescuento () / 100))
	}
}