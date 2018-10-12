class UserException inherits Exception { }

class Personaje {
	var property monedas = 100
	var property hechizoPreferido 
	/*
	 * Ese lstArtefactos no lo puedo poner directo
	 * porque hay que instanciar 
	 * los objetos primero. Solo collarDivino queda como objeto
	 */
    // var lstArtefactos = [espadaDestino,collarDivino,mascaraOscura]
    var lstArtefactos = []
    var property valorBaseLucha = 1
    const valorBase = 3

	method comprar(artefacto){
		if(artefacto.precio()>monedas){
			throw new UserException("No tiene suficientes monedas")
		}
		monedas -=artefacto.precio()
		self.agregarArtefacto(artefacto)
	}
    method agregarArtefacto (nuevoArtefacto) { //PUNTO 2.2
        lstArtefactos.add(nuevoArtefacto)
    }
    method removerArtefacto(artefactoARemover){ //PUNTO 2.2
        lstArtefactos.remove(artefactoARemover)
    }
    method habilidadLucha(){ //PUNTO 2.3
        var sumaUnidadesAportadasPorArtefactos = lstArtefactos.sum({artefacto => artefacto.poder()})
        return (valorBaseLucha + sumaUnidadesAportadasPorArtefactos) 
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
    	if ((hechizoPreferido.precio()/2 + monedas) < hechizoNuevo.precio()){
    		throw new UserException("Monedas insuficientes para canjear ese hechizo")
    	}
    	monedas -= 0.max(hechizoNuevo.precio()-hechizoPreferido.precio()/2)
    	hechizoPreferido=hechizoNuevo
    }
     //este se reemplaza por el property de valorBaseLucha
  
   /* 
    * method cambiarValorBaseLucha(nuevoValor){ //PUNTO 2.1
    * valorBaseLucha = nuevoValor}
    */
        
    // este se reemplaza llamandola const
    
   /*
    * method valorBase(){return 3} */ 
   
    //este se reemplaza por el property de hechizoPreferido
    
   	/* method cambiarHechizoPreferido(nuevoHechizoPreferido){ //PUNTO 1.3
   	 * hechizoPreferido = nuevoHechizoPreferido}
   	 */
  
}

class Armadura{
	
	var property refuerzo = ninguno
	var valorBase
	//method cambiarRefuerzo(nuevoRefuerzo){refuerzo = nuevoRefuerzo}
	method poder(){return valorBase + refuerzo.valorLucha()}
	method precio(){
 		if ((refuerzo == CotasDeMalla) or (refuerzo == ninguno)) {
			return refuerzo.precio()
		} else {return valorBase + refuerzo.precio()}
		
	}
}

class Arma{
	const property precio = 5* self.poder()
	method poder(){return 3}
}

class Mascara{
	var indiceOscuridad
	method establecerIndiceOscuridad(nuevoIndice){
		if ((nuevoIndice < 0) or (nuevoIndice > 1)){throw new UserException("Se excedió del indice")} 
		indiceOscuridad = nuevoIndice
			
	}
	method poder(){
		return 4.min((fuerzaOscura.valorFuerzaOscura()/2)*indiceOscuridad)
       /*
        * if ((fuerzaOscura.valorFuerzaOscura()/2)>=4){
        * return (fuerzaOscura.valorFuerzaOscura()/2)
        * }
        * else {return 4}
        */ 
               
    }
}

class Logos{
	const property precio = self.poder()
	var property nombre
	var property valorASerMultiplicado
	method poder(){
    return nombre.length() * valorASerMultiplicado
    }
    method hechizoPoderoso(){
        return (self.poder() > 15)
    }
}


object collarDivino{
    var property cantPerlas = 5
	const property precio = 2*cantPerlas
    /*
     * method setearCantPerlas (nuevaCantPerlas) {
     * cantPerlas = nuevaCantPerlas
     * }
     */
    
    method poder(){return cantPerlas}
}





object hechizoBasico{
	
	const property precio = 10
    method poder(){
        return 10
    }
    method hechizoPoderoso(){
        return false
    }
}

object fuerzaOscura{
    var property valorFuerza = 5
    method valorFuerzaOscura(){
        return valorFuerza
    }
    
    method eclipse(){ //PUNTO 1.4
        valorFuerza = valorFuerza *2
    }
    
     /* 
     * method cambiarValorFuerza(nuevoValor){
     * valorFuerza = nuevoValor}
     */
}

class CotasDeMalla{
   const property precio = valorLucha/2
   var property valorLucha
}

object bendicion {
    /* var nombre = rolando 
     * method cambiarNombre(nuevo){nombre = nuevo}
     */ 
    const property precio = 0
    method valorLucha(personaje){return personaje.nivelDeHechiceria()}
   
}

object ninguno{
	const property precio = 2
    method valorLucha(){return 0}
}

object espejo{
   /* 
    * var personaje = rolando
    *  method cambiarPersonaje(nuevoPersonaje){ personaje = nuevoPersonaje}
    */
	const property precio = 90
    method poder(personaje){
        var listaPersonajePoderes = personaje.listaArtefactos()
        if (listaPersonajePoderes.isEmpty()){
            return 0
        }  //rolando.artefactosSin(self)
        else{return listaPersonajePoderes.filter({x => x!=self}).max({x=>x.poder()})}
    }
}

object libroDeHechizos{
	const espectroMalefico =new Logos(nombre="espectro Malefico",valorASerMultiplicado=1)
	const property precio = 10* listaDeHechizos.size()+ unidadDeHechiceriaTotalPoderosos
	const property unidadDeHechiceriaTotalPoderosos = listaDeHechizos.filter({hechizos => hechizos.hechizoPoderoso()}).sum({hechizos => hechizos.poder()}) 
    var listaDeHechizos = [espectroMalefico, hechizoBasico]

    method poder(){
        if (listaDeHechizos.isEmpty()){
            return 0
        }
        else{return listaDeHechizos.map({x => if (x.hechizoPoderoso()){return x.poder()} else{return 0}}).sum({x=> x.poder()})}
    }
}

/*
 * object armadura{
 * var refuerzo = ninguno
 * const valorBase = 2
 * method cambiarRefuerzo(nuevoRefuerzo){refuerzo = nuevoRefuerzo}
 * method poder(){return valorBase + refuerzo.valorLucha()}
 * }
 */

 
/* 
 * object hechizo{
 * var hechizo=hechizoBasico
 * method cambiarHechizo(nuevoHechizo){hechizo = nuevoHechizo}
 * method valorLucha(){return hechizo.poder()}
 * }
 * */
 

/* object rolando {
	
    var hechizoPreferido = espectroMalefico
    var lstArtefactos = [espadaDestino,collarDivino,mascaraOscura]
    var valorBaseLucha = 1
    

    method agregarArtefacto (nuevoArtefacto) { //PUNTO 2.2
        lstArtefactos.add(nuevoArtefacto)
    }
    method removerArtefacto(artefactoARemover){ //PUNTO 2.2
        lstArtefactos.remove(artefactoARemover)
    }
    method cambiarValorBaseLucha(nuevoValor){ //PUNTO 2.1
        valorBaseLucha = nuevoValor
    }
    method habilidadLucha(){ //PUNTO 2.3
        var sumaUnidadesAportadasPorArtefactos = lstArtefactos.sum({artefacto => artefacto.poder()})
        return (valorBaseLucha + sumaUnidadesAportadasPorArtefactos) 
    }
    method nivelDeHechiceria(){ //PUNTO 1.1
          return (self.valorBase() * hechizoPreferido.poder()) + fuerzaOscura.valorFuerzaOscura()
    }
    method cambiarHechizoPreferido(nuevoHechizoPreferido){ //PUNTO 1.3
        hechizoPreferido = nuevoHechizoPreferido
    }
    method fuerzaOscura(){
        return fuerzaOscura
    }
    method valorBase(){
        return 3
    }
    method seCreePoderoso(){ //PUNTO 1.5
        return hechizoPreferido.hechizoPoderoso()
    }
    method luchaMayorHechiceria(){ //PUNTO 2.4
        return self.habilidadLucha()>self.nivelDeHechiceria()
    }
    method listaArtefactos(){return lstArtefactos}
    method estaCargado(){return lstArtefactos.size()>=5}
} */

//ESTE OBJETO SE DEBE INSTANCIAR DE LA CLASE ARMA

/*
 * object espadaDestino{
 * method poder(){return 3}  }
 * 
 */