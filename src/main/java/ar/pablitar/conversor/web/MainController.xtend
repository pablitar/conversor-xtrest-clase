package ar.pablitar.conversor.web

import org.uqbar.xtrest.api.annotation.Controller
import org.uqbar.xtrest.api.annotation.Get
import org.uqbar.xtrest.api.XTRest
import ar.pablitar.conversor.Conversores
import org.uqbar.xtrest.api.annotation.Post
import org.uqbar.xtrest.api.annotation.Body
import org.uqbar.xtrest.json.JSONUtils
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.Data
import java.util.List

class Saludador {
	def saludar() {
		"Hola Mundo"
	}
}

class PedidoConversionSimple {
	@Accessors
	Double millas
}

class PedidoConversion {
	@Accessors
	Double valor
	@Accessors
	String nombreConversor
}

@Data
class RespuestaConversores {
	List<String> conversores
}


class RespuestaConversionSimple {
	
	@Accessors
	Double km
	
	new (Double km) {
		this.km = km		
	}
}

@Data
class RespuestaConversion {
	String nombreConversor
	Double valor
}

@Controller
class MainController {
	extension JSONUtils = new JSONUtils

	@Get("/hola")
	def hello() {
		// EESTO NO SE HACEEEEE
		response.contentType = "text/html"
		ok(
			"<h2>" + new Saludador().saludar + "</h2>"
		)
	}

	@Get("/convertir")
	def convertir(String millas, String sufijo) {
		val millasDouble = Double.parseDouble(millas)
		val respuesta = Conversores.millasAKilometros.convertir(millasDouble)

		ok(respuesta.toString + " " + sufijo)
	}

	@Get("/convertir/:millas")
	def convertirConParametroEnPath() {
		val millasDouble = Double.parseDouble(millas)
		val respuesta = Conversores.millasAKilometros.convertir(millasDouble)

		ok(respuesta.toString)
	}

//	@Post("/convertir")
//	def convertirPost(@Body String body) {
//		val pedidoConversion = body.fromJson(PedidoConversionSimple)
//		
//		val respuesta = 
//			new RespuestaConversionSimple(
//				Conversores.millasAKilometros.convertir(pedidoConversion.millas)
//				
//				)
//		response.contentType = "application/json"
//		
//		ok(respuesta.toJson)
//	}
	
	@Post("/convertir")
	def convertirConConversor(@Body String body) {
		val pedidoConversion = body.fromJson(PedidoConversion)
		
		val conversor = Conversores.todos.findFirst[c|c.nombre == pedidoConversion.nombreConversor]
		
		ok(new RespuestaConversion(conversor.nombre, conversor.convertir(pedidoConversion.valor)).toJson)		
	}
	
	@Get("/conversores")
	def convertirConParametroEnPath() {
		response.contentType = "application/json"
		ok(new RespuestaConversores(Conversores.todos.map[it.nombre].toList).toJson)
	}


	def static void main(String[] args) {
		XTRest.start(MainController, 9000)
	}

}
