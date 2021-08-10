require 'estrategia_conflictos'

class Trait

  def initialize(modulo)
    @estrategia = ExcepcionConflicto.new(self)
    @modulo = modulo
  end

  def modulo
    @modulo
  end

  def *(estrategia_nueva)
    @estrategia = estrategia_nueva
  end

  def +(otro_trait)
    metodos_mios = @modulo.instance_methods
    metodos_del_otro = otro_trait.modulo.instance_methods
    metodos_conflictivos = metodos_mios & metodos_del_otro
    metodos_no_conflictivos = (metodos_mios + metodos_del_otro) - metodos_conflictivos

    suma_traits = Module.new
    if metodos_conflictivos.empty?
      definir_metodos(suma_traits,otro_trait,metodos_no_conflictivos)
      trait_resultante = Trait.new(suma_traits)
    elsif self === otro_trait
      self
    else
      @estrategia.resolver_conflictos(suma_traits,otro_trait,metodos_conflictivos)
      trait_resultante = Trait.new(suma_traits)
    end
  end

  def -(methods)
    nuevo_modulo = Module.new
    metodos_mios = @modulo.instance_methods

    if(methods.is_a?(Symbol))
      metodos_mios.each do |m|
        if(!(m == methods))
          metodo = @modulo.instance_method(m).bind(nuevo_modulo)
          nuevo_modulo.define_method(m,&metodo)
        end
      end
    else
      metodos_mios.each do |m|
        if(!methods.include? m)
          metodo = @modulo.instance_method(m).bind(nuevo_modulo)
          nuevo_modulo.define_method(m,&metodo)
        end
      end
    end
    nuevo_trait = Trait.new(nuevo_modulo)
    nuevo_trait * @estrategia
    nuevo_trait
  end

  def <<(un_hash)
    nuevo_modulo = Module.new
    un_hash.each do |metodo, apodo|
      metodo = @modulo.instance_method(metodo).bind(nuevo_modulo)
      nuevo_modulo.define_method(apodo, &metodo)
    end
    nuevo_trait = Trait.new(nuevo_modulo)
    nuevo_trait * @estrategia
    nuevo_trait
  end

  private def definir_metodos(trait_nuevo,otro_trait,metodos_a_definir)
    metodos_a_definir.each { |m|
      if @modulo.instance_methods.include? m
        metodo = @modulo.instance_method(m).bind(trait_nuevo)
        trait_nuevo.define_method(m, &metodo)
      else
        metodo = otro_trait.modulo.instance_method(m).bind(trait_nuevo)
        trait_nuevo.define_method(m, &metodo)
      end
    }
  end
end