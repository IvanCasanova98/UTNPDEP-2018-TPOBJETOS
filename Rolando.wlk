class FaltanMonedas inherits Exception { }
class IndiceExcedido inherits Exception { }
class DemasiadaCarga inherits Exception { }
class NoEstaArtefacto inherits Exception { }

 class Personaje {
	var capacidadDeCarga
	var property monedas = 100
	var property hechizoPreferido 
    var lstArtefactos = []
    var property valorBaseLucha = 1
    const valorBase = 3
	var sumaDePesosArtefactos = lstArtefactos.sum({artefactos => artefactos.pesoTotal()})
	method validarCarga(){if (capacidadDeCarga< sumaDePesosArtefactos) 
		throw new DemasiadaCarga("Este personaje no puede llevar mas artefactos")
	}
	
	method validarMonedasSuficientes(precio){
	 if(precio>monedas) throw new FaltanMonedas("No tiene suficientes monedas")
	}
     method agregarArtefacto (nuevoArtefacto) { //PUNTO 2.2
        self.validarCarga()
        lstArtefactos.add(nuevoArtefacto)
    }
    method removerArtefacto(artefactoARemover){ //PUNTO 2.2
        lstArtefactos.remove(artefactoARemover)
    }
    method sumaTodosArtefactos(){return lstArtefactos.sum({artefacto => artefacto.puntosLucha(self)})}
    method habilidadLucha(){ //PUNTO 2.3
        return (valorBaseLucha + self.sumaTodosArtefactos()) 
    }
    method nivelDeHechiceria(){ //PUNTO 1.1
          return (valorBase * hechizoPreferido.poder()) + fuerzaOscura.valorFuerzaOscura()
    }    method fuerzaOscura(){
        return fuerzaOscura
    }
    method seCreePoderoso(){ //PUNTO 1.5
        return hechizoPreferido.hechizoPoderoso()
    }
    method luchaMayorHechiceria(){ //PUNTO 2.4
        return self.habilidadLucha()>self.nivelDeHechiceria()
    }
    method listaArtefactos(){return lstArtefactos}
    method listaArtefactosSin(artefacto){return self.listaArtefactos().filter({artefactos=>artefactos!=artefacto}) }
    method estaCargado(){return lstArtefactos.size()>=5}
    method comprar(artefacto,comercio){
    	
    	comercio.verificarSiEsta(artefacto)
		self.validarMonedasSuficientes(artefacto.precio(self)+ comercio.iva(artefacto))
		monedas -=artefacto.precio(self) + comercio.iva(artefacto)
		self.agregarArtefacto(artefacto)
		comercio.removerArtefacto(artefacto)
	}
	
	 method canjearHechizo(hechizoNuevo){
    	var importe= 0.max(hechizoNuevo.precio(self)-hechizoPreferido.precio(self)/2)
    	self.validarMonedasSuficientes(importe)	
		monedas -= importe
    	hechizoPreferido=hechizoNuevo
	}
	

    }
    

 class Artefacto{
	var property peso
	var property diasDeUso
	method desgaste()= diasDeUso/1000
	method pesoTotal()= peso - self.desgaste()
}


 class Armadura inherits Artefacto{
	
	var property refuerzo = ninguno
	var property valorBase
	method puntosLucha(personaje){return valorBase + refuerzo.valorLucha(personaje)}
	method precio() {return refuerzo.precioRefuerzo(self)}
	method pesoExtra() = refuerzo.pesoRefuerzo()
 	override method pesoTotal(){ return super() + self.pesoExtra() }
	}
	
	
 class Arma inherits Artefacto{
	const puntosLucha = 3
	method puntosLucha(_personaje){return puntosLucha}
	method precio() = 5* peso
}


 class Mascara inherits Artefacto{
 	var indiceOscuridad
	method establecerIndiceOscuridad(nuevoIndice){
		if ((nuevoIndice < 0) or (nuevoIndice > 1)){throw new IndiceExcedido("Se excedió del indice")} 
		indiceOscuridad = nuevoIndice
		}
	method calcularFuerza () {return 4.max((fuerzaOscura.valorFuerzaOscura()/2)*indiceOscuridad)}
	method puntosLucha(_personaje){return self.calcularFuerza()}
	method pesoExtra(){ if ((self.calcularFuerza() - 3) > 3) return self.calcularFuerza() - 3 else return 0}
	override method pesoTotal(){return super() + self.pesoExtra()}
	method precio(){
		return 10*indiceOscuridad
	}
	
		}
	
 
 class Logos{
	var property nombre
	var property valorASerMultiplicado
	method precio() = self.poder()
	method precioRefuerzo(armadura)=self.poder() + armadura.valorBase()
	method poder(){
    return nombre.length() * valorASerMultiplicado}
    
    method hechizoPoderoso(){
    return (self.poder() > 15)
   	}
   	 method valorLucha(_personaje){return self.poder()}
    method esPar() = self.poder().even()
    method pesoRefuerzo()= if(self.esPar())return 2 else return 1	
}


 object hechizoBasico inherits Logos(nombre="hechizo basico",valorASerMultiplicado=1){
   var poderBasico=10
   override method poder(){
        return poderBasico
    }
    override method hechizoPoderoso(){
        return false
    }
 }
 
 
 object hechizoComercial inherits Logos(nombre="el hechizo comercial",valorASerMultiplicado=0.2) {
   var multiplicador=2
   override method poder(){
   	return super()*multiplicador  	
   }
    }
    object collarDivino inherits Artefacto{
    var property cantPerlas= 5
    method precio() = 2*cantPerlas
    method puntosLucha(personaje){return cantPerlas}
    method pesoExtra() = cantPerlas*0.5
    override method pesoTotal() {return super()+ self.pesoExtra()}
}


 object fuerzaOscura{
    var property valorFuerza = 5
    method valorFuerzaOscura(){
        return valorFuerza
    }
    
    method eclipse(){ //PUNTO 1.4
        valorFuerza = valorFuerza *2}
        }
        
        
 class Refuerzo{
	method precioRefuerzo (armadura)= armadura.valorBase()
        }
        
        class CotasDeMalla{
   const peso = 1
   var property puntosLucha
   method valorLucha(personaje){return puntosLucha}
   method precioRefuerzo(armadura) = puntosLucha/2
   method pesoRefuerzo() = peso
}

 object bendicion {
    method valorLucha(personaje){return personaje.nivelDeHechiceria()}
    method precioRefuerzo (armadura)= armadura.valorBase()
    method pesoRefuerzo() = 0}
    
    object ninguno{
	method precioRefuerzo(armadura) = 2
    method valorLucha(personaje){return 0}
    method pesoRefuerzo() = 0}
    
    object espejo inherits Artefacto{
 	method precio() = 90}
 	
 	object libroDeHechizos{
	var listaDeHechizos = [hechizoBasico]
	method poder(){
		return listaDeHechizos.filter({hechizos => hechizos.hechizoPoderoso()}).sum({hechizos => hechizos.poder()})
		}
   	method agregarHechizo(hechizo){listaDeHechizos.add(hechizo)}
 	method precio() = 10* listaDeHechizos.size()+ self.poder()
 }
 
 class NPC_Facil inherits Personaje{
	}
	
class NPC_Moderado inherits Personaje{
	override method habilidadLucha() = super()*2
	}
	
class NPC_Dificil inherits Personaje{
	override method habilidadLucha() = super()*4
	}
	
	
class Comercio{
	var lstArtefactos = []
	var minimoNoImponible=100
	var situacionImpositiva 
	var iVA = 0.21
	method removerArtefacto(artefacto) = lstArtefactos.remove(artefacto)
	method verificarSiEsta(artefacto) {if(lstArtefactos.filter({x => x == artefacto}).isEmpty()) throw new NoEstaArtefacto("El comercio no posee ese artefacto")} 
}

class ComercianteIndependiente inherits Comercio{
	var comision
	method iva(artefacto){return comision}
	method cambiarSituacionImpositiva(){
		if (comision < comision* iVA *2){situacionImpositiva = new ComercianteRegistrado()}
		else {comision = comision*2}
	}
}

class ComercianteRegistrado inherits Comercio{
	method iva(artefacto){return artefacto.precio() * iVA} 
	method cambiarSituacionImpositiva() {
		situacionImpositiva = new ComercianteImpuestoGanancias()
	}
	
}

class ComercianteImpuestoGanancias inherits Comercio{
	method iva(artefacto){
		if (artefacto.precio() < minimoNoImponible) return 0
		else {return (artefacto.precio() - minimoNoImponible)*0.35}
	}
	method cambiarSituacionImpositiva(){}
	
}
	
	