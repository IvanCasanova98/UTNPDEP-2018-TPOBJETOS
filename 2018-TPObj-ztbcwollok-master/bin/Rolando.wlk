class UserException inherits Exception { }

class Personaje {
	var property monedas = 100
	var property hechizoPreferido 
    var lstArtefactos = []
    var property valorBaseLucha = 1
    const valorBase = 3

	method comprar(artefacto){
		if(artefacto.precio(self)>monedas){
			throw new UserException("No tiene suficientes monedas")
		}
		monedas -=artefacto.precio(self)
		self.agregarArtefacto(artefacto)
	}
    method agregarArtefacto (nuevoArtefacto) { //PUNTO 2.2
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
    method estaCargado(){return lstArtefactos.size()>=5}
    
    method canjearHechizo(hechizoNuevo){
    	if ((hechizoPreferido.precio(self)/2 + monedas) < hechizoNuevo.precio(self)){
    		throw new UserException("Monedas insuficientes para canjear ese hechizo")
    	}
    	monedas -= 0.max(hechizoNuevo.precio(self)-hechizoPreferido.precio(self)/2)
    	hechizoPreferido=hechizoNuevo
    }
}

class Armadura{
	
	var property refuerzo = ninguno
	var property valorBase
	method puntosLucha(personaje){return valorBase + refuerzo.valorLucha(personaje)}
	method precio(personaje){
 	return refuerzo.precioRefuerzo(self)
		
	}
}

class Arma{
	method puntosLucha(_personaje){return 3}
	method precio(_personaje) = 5* self.puntosLucha(_personaje)
}

class Mascara{
	var indiceOscuridad
	method establecerIndiceOscuridad(nuevoIndice){
		if ((nuevoIndice < 0) or (nuevoIndice > 1)){throw new UserException("Se excedió del indice")} 
		indiceOscuridad = nuevoIndice
			
	}
	method puntosLucha(_personaje){
		return 4.max((fuerzaOscura.valorFuerzaOscura()/2)*indiceOscuridad)
     }
}

class Logos{
	var property nombre
	var property valorASerMultiplicado
	method precio(_personaje) = self.poder()
	method precioRefuerzo(armadura)=self.poder() + armadura.valorBase()
	method poder(){
    return nombre.length() * valorASerMultiplicado
    }
    method hechizoPoderoso(){
        return (self.poder() > 15)
    }
    method puntosLucha(_personaje){return self.poder()}
    method valorLucha(_personaje){return self.poder()}
}


object collarDivino{
    var property cantPerlas= 5
    method precio(_personaje) = 2*cantPerlas
       method puntosLucha(personaje){return cantPerlas}
}

object hechizoBasico{
	method precio(_personaje) = 10
	method precioRefuerzo(armadura)=10 + armadura.valorBase()
    method poder(){
        return 10
    }
    method hechizoPoderoso(){
        return false
    }
    method puntosLucha(_personaje){return self.poder()}
    method valorLucha(_personaje){return self.poder()}
}

object fuerzaOscura{
    var property valorFuerza = 5
    method valorFuerzaOscura(){
        return valorFuerza
    }
    
    method eclipse(){ //PUNTO 1.4
        valorFuerza = valorFuerza *2
    }
    
  }

class CotasDeMalla{
   var property puntosLucha
   method valorLucha(personaje){return puntosLucha}
   method precioRefuerzo(_personaje) = puntosLucha/2
}

object bendicion {
    method valorLucha(personaje){return personaje.nivelDeHechiceria()}
    method precioRefuerzo (armadura)= armadura.valorBase()
}

object ninguno{
	method precioRefuerzo(armadura) = 2
    method valorLucha(personaje){return 0}
}

object espejo{
	method precio(_personaje) = 90
    method puntosLucha(personaje){
        if (personaje.listaArtefactos().all({artefactos=> artefactos==self})){
            return 0
        }  else{
        return personaje.listaArtefactos().filter({artefactos=>artefactos!=self}).map({artefactos=>artefactos.puntosLucha(personaje)}).max()
        		
        }
    }
}

object libroDeHechizos{
	var listaDeHechizos = [hechizoBasico]
	method poder(){
		return listaDeHechizos.filter({hechizos => hechizos.hechizoPoderoso()}).map({hechizos => hechizos.poder()}).sum()
	}
   	method agregarHechizo(hechizo){listaDeHechizos.add(hechizo)}
    method puntosLucha(_personaje){
    	return listaDeHechizos.filter({hechizos => hechizos.hechizoPoderoso()}).map({hechizos => hechizos.poder()}).sum()
    	
    }
	method precio(_personaje) = 10* listaDeHechizos.size()+ self.puntosLucha(_personaje)
//    method puntosLucha(_personaje){
//        if (listaDeHechizos.isEmpty()){
//            return 0
//        }
//        else{return listaDeHechizos.filter({hechizo => 
//        	if (hechizo.hechizoPoderoso()){return hechizo.poder()} 
//        	else {return 0} }).sum({x=> x.poder()})}
//    }
}

