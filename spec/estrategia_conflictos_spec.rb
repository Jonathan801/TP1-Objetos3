require 'rspec'
require 'trait'
require 'estrategia_conflictos'
require 'metodos'
=begin
trait Guerrero do
  def defensa
    10
  end

  def ataque
    100
  end
end

trait Defensor do
  def defensa
    20
  end
end

describe 'test estrategia de conflictos' do

  it 'Estrategia utilizar uno' do
    trait_guerrero = Guerrero
    trait_defensor = Defensor

    nuevo_trait = Trait.new
    metodos_conflictivos = trait_guerrero.methods(false) & trait_defensor.methods(false)

    estrategia_usar_uno = UsarPrimerTrait.new(trait_guerrero)

    trait_resultante = estrategia_usar_uno.resolver_conflictos(nuevo_trait,trait_defensor,metodos_conflictivos)

    expect(trait_resultante.defensa).to eq(10)
  end

  it 'Estrategia aplicar funcion' do
    trait_guerrero = Guerrero
    trait_defensor = Defensor

    nuevo_trait = Trait.new
    metodos_conflictivos = trait_guerrero.methods(false) & trait_defensor.methods(false)

    funcion_a_aplicar = :+
    estrategia_aplicar_funcion = AplicarFuncion.new(trait_guerrero,funcion_a_aplicar)

    trait_resultante = estrategia_aplicar_funcion.resolver_conflictos(nuevo_trait,trait_defensor,metodos_conflictivos)

    expect(trait_resultante.defensa).to eq(30)
  end

  it 'Estrategia aplicar condicion' do
    #defensa de 10
    trait_guerrero = Guerrero
    #defensa de 20
    trait_defensor = Defensor

    nuevo_trait = Trait.new
    metodos_conflictivos = trait_guerrero.methods(false) & trait_defensor.methods(false)

    def mayor_a_15(un_numero)
      un_numero > 15
    end

    condicion_a_aplicar = method("mayor_a_15")
    estrategia_aplicar_condicion = AplicarCondicion.new(trait_guerrero,condicion_a_aplicar)

    trait_resultante = estrategia_aplicar_condicion.resolver_conflictos(nuevo_trait,trait_defensor,metodos_conflictivos)

    expect(trait_resultante.defensa).to eq(20)
  end

  it 'Estrategia n2' do

    trait_guerrero = Guerrero
    trait_defensor = Defensor

    nuevo_trait = Trait.new
    metodos_conflictivos = trait_guerrero.methods(false) & trait_defensor.methods(false)
    estrategia_aplicar_segunda = OrdenDeAparicion.new(trait_guerrero)

    trait_resultante = estrategia_aplicar_segunda.resolver_conflictos(nuevo_trait,trait_defensor,metodos_conflictivos)

    expect(trait_resultante.defensa).to eq(20)

  end

  it 'Se decide cambiar de estrategia de resolucion de conflictos' do
    class Fantasma

      mayor_a_15 = proc do |un_numero| un_numero > 15 end
      estrategia_elegida = AplicarCondicion.new(Guerrero, mayor_a_15)

      #Defensa = 10
      Guerrero * estrategia_elegida
      #Defensa = 20
      Defensor * estrategia_elegida

      uses Guerrero + Defensor
    end

    fantasma = Fantasma.new

    expect(fantasma.defensa).to eq(20)

  end

  it 'se decide usar la estrategia n2 con Defensor + Guerrero y deberia dar 10 ' do

    estrategia_elegida= OrdenDeAparicion.new(Defensor)

    #Defensa = 10
    Guerrero * estrategia_elegida
    #Defensa = 20
    Defensor * estrategia_elegida

    clase_fantasma = Class.new do
      uses Defensor + Guerrero
        def nombre()
          'Casper'
        end

    end

    fantasma = clase_fantasma.new

    expect(fantasma.defensa).to eq(10)
  end

  it 'se decide usar la estrategia n2 con Defensor + Guerrero y deberia dar 20 ' do

    estrategia_elegida= OrdenDeAparicion.new(Guerrero)

    #Defensa = 10
    Guerrero * estrategia_elegida
    #Defensa = 20
    Defensor * estrategia_elegida

    clase_fantasma = Class.new do
      uses Guerrero + Defensor
      def nombre()
        'Casper'
      end

    end

    fantasma = clase_fantasma.new

    expect(fantasma.defensa).to eq(20)
    expect(fantasma.ataque).to eq(100)
    expect(fantasma.nombre).to eq('Casper')
  end
end
=end