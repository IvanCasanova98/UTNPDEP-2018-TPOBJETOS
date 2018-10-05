object rolando {
	
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
}
object espadaDestino{
    method poder(){return 3}
}

object collarDivino{
    var cantPerlas = 5

    method setearCantPerlas (nuevaCantPerlas) {
        cantPerlas = nuevaCantPerlas
    }
    method poder(){return cantPerlas}
}

object mascaraOscura{
    method poder(){
        if ((fuerzaOscura.valorFuerzaOscura()/2)>=4){
            return (fuerzaOscura.valorFuerzaOscura()/2)
        }
        else {return 4}
    }
}

object espectroMalefico{
    var nombre = "espectro Malefico"

    method cambiarNombre(nuevoNombre){ //PUNTO 2.1
        nombre = nuevoNombre
    }
    method poder(){
    return nombre.length()
    }
    method hechizoPoderoso(){
        return (self.poder() > 15)
    }
}

object hechizoBasico{

    method poder(){
        return 10
    }
    method hechizoPoderoso(){
        return false
    }
}

object fuerzaOscura{
    var valorFuerza = 5
    method valorFuerzaOscura(){
        return valorFuerza
    }
    method cambiarValorFuerza(nuevoValor){
        valorFuerza = nuevoValor
    }
    method eclipse(){ //PUNTO 1.4
        valorFuerza = valorFuerza *2
    }
}

object armadura{
    var refuerzo = ninguno
    const valorBase = 2
    method cambiarRefuerzo(nuevoRefuerzo){refuerzo = nuevoRefuerzo}
    method poder(){return valorBase + refuerzo.valorLucha()}
}

object cotaDeMalla{
    method valorLucha(){return 1}
}

object bendicion {
    var nombre = rolando
    method valorLucha(){return nombre.nivelDeHechiceria()}
    method cambiarNombre(nuevo){nombre = nuevo}
}

object hechizo{
    var hechizo=hechizoBasico
    method cambiarHechizo(nuevoHechizo){hechizo = nuevoHechizo}
    method valorLucha(){return hechizo.poder()}
}
object ninguno{
    method valorLucha(){return 0}
}

object espejo{
    var personaje = rolando
    method cambiarPersonaje(nuevoPersonaje){
        personaje = nuevoPersonaje
    }
    method poder(){
        var listaPersonajePoderes = personaje.listaArtefactos()
        if (listaPersonajePoderes.isEmpty()){
            return 0
        }  //rolando.artefactosSin(self)
        else{return listaPersonajePoderes.filter({x => x!=self}).max({x=>x.poder()})}
    }
}

object libroDeHechizos{
    var listaDeHechizos = [espectroMalefico, hechizoBasico]

    method poder(){
        if (listaDeHechizos.isEmpty()){
            return 0
        }
        //FALTA CORREGIR ESTO
        else{return listaDeHechizos.map({x => if (x.hechizoPoderoso()){return} else{return 0}}).sum({x=> x.poder()})}
    }
}

