def Object.const_missing(name)
  name
end

def trait(name,&block)
  nuevo_modulo = Module.new
  nuevo_modulo.module_eval(&block)
  nuevo_trait = Trait.new(nuevo_modulo)
  Object.const_set(name,nuevo_trait)
  nuevo_trait
end

def uses(name)
  #Le resto los metodos que no me interesan
  modulo_base = name.modulo
  metodos_de_modulo = modulo_base.instance_methods
  metodos_de_modulo.each do |m|
    #El .name.to_s sirve para que solo quede el nombre del ataque a secas "ataque"
    metodo = modulo_base.instance_method(m).bind(self)
    unless self.respond_to?(m)
      self.define_method(m, metodo)
    end
  end
end