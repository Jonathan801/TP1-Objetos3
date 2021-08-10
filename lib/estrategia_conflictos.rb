class ResolucionDeConflictos

  def initialize(trait)
    @trait = trait
  end

  def resolver_conflictos(nuevo_trait,trait_a_sumar,metodos_conflictivos)
    raise 'Not Implemented'
  end
end

class ExcepcionConflicto < ResolucionDeConflictos
  def resolver_conflictos(nuevo_trait, trait_a_sumar, metodos_conflictivos)
    unless metodos_conflictivos.empty?
      raise "Existen metodos en conflicto"
    end
  end
end

class UsarPrimerTrait < ResolucionDeConflictos
  def resolver_conflictos(nuevo_trait, trait_a_sumar, metodos_conflictivos)
    metodos_conflictivos.each do |metodo_conflictivo|
      nuevo_trait.define_singleton_method(metodo_conflictivo,&@trait.method(metodo_conflictivo))
    end
    nuevo_trait
  end
end


class OrdenDeAparicion < ResolucionDeConflictos
  def resolver_conflictos(nuevo_trait, trait_a_sumar, metodos_conflictivos)
    trait_original=@trait
    metodos_conflictivos.each { |m|
      p = Proc.new {
        trait_original.send(m)
        trait_a_sumar.send(m)
      }
      nuevo_trait.define_singleton_method(m,p)
    }
    nuevo_trait
  end
end

class AplicarFuncion < ResolucionDeConflictos
  def initialize(trait,func)
    super(trait)
    @function = func
  end

  def resolver_conflictos(nuevo_trait, trait_a_sumar, metodos_conflictivos)
    ##valores = metodos_conflictivos.map {|element| method(element).call}
    metodos_conflictivos.each do |metodo_conflictivo|
      valores = [@trait.method(metodo_conflictivo).call,
                 trait_a_sumar.method(metodo_conflictivo).call]
      resultado = valores.inject(@function)
      proc = Proc.new {resultado}
      nuevo_trait.define_singleton_method(metodo_conflictivo,proc)
    end
    nuevo_trait
  end
end

class AplicarCondicion < ResolucionDeConflictos

  def initialize(trait, condicion)
    super(trait)
    @condicion = condicion
  end

  def resolver_conflictos(nuevo_trait, trait_a_sumar, metodos_conflictivos)
    ##valores = metodos_conflictivos.map {|element| method(element).call}
    metodos_conflictivos.each do |metodo_conflictivo|
      valores = [@trait.method(metodo_conflictivo).call,
                 trait_a_sumar.method(metodo_conflictivo).call]
      resultado = valores.select do |res|
        @condicion.call(res)
      end
      proc = Proc.new {resultado[0]}
      nuevo_trait.define_singleton_method(metodo_conflictivo,proc)
    end
    nuevo_trait
  end

end