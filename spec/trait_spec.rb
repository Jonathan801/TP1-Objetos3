require 'rspec'
require 'metodos'
require 'trait'


trait Defensa do
  def defensa
    0
  end

  def presentarse(mensaje)
    mensaje
  end
end

trait Ataque do
  def ataque
    0
  end
end

trait MegaAtacante do
  def ataque
    100
  end

  def danger
    'Im the danger'
  end
end

trait Espia do
  def sigilo
    200
  end
end

trait LanzaYEscudo do
  def ataque
    30
  end

  def defensa
    20
  end
end

trait MegaGuerrero do
  def ataque
    100
  end

  def defensa
    40
  end
end

describe 'tests respecto al trait base' do

  it 'se usan dos traits particulares separados y la clase agrega sus mensajes' do
    class Fantasma
      uses Defensa
      uses Ataque

      def nombre()
        'Casper'
      end

    end

    fantasma = Fantasma.new

    expect(fantasma.defensa).to eq(0)
    expect(fantasma.ataque).to eq(0)

  end

  it 'una clase involucra un solo trait y solo agrega los mensajes de este' do
    clase_fantasma = Class.new do
      uses Defensa

      def nombre()
        'Casper'
      end
    end

    fantasma = clase_fantasma.new

    expect(fantasma.respond_to?(:defensa)).to eq(true)
    expect(fantasma.respond_to?(:ataque)).to eq(false)
  end

  it 'una clase incorpora metodos con parametros provenientes de un trait' do
    class Fantasma
      uses Defensa
    end
    fantasma = Fantasma.new
    expect(fantasma.presentarse("Tengo defensa")).to eq("Tengo defensa")
  end

  it 'una clase agrega un trait que tiene mas de un metodo y otro trait que no tiene metodos en comun' do
    clase_fantasma = Class.new do
      uses MegaAtacante
      uses Defensa

      def nombre()
        'Casper'
      end
    end

    fantasma = clase_fantasma.new

    expect(fantasma.defensa).to eq(0)
    expect(fantasma.ataque).to eq(100)
    expect(fantasma.danger).to eq('Im the danger')

  end

  it 'el mensaje de una clase que comparte el nombre con un mensaje de un trait, tiene prioridad' do
    clase_fantasma = Class.new do
      #defensa = 0
      uses Defensa

      def defensa()
        30
      end
    end

    fantasma = clase_fantasma.new

    expect(fantasma.defensa).to eq(30)
  end

  it 'self en un trait hace referencia a la clase que lo usa y no al trait' do
    trait Impostor do
      def soy_yo
        self
      end
    end

    class Fantasma
      uses Impostor
    end

    fantasma = Fantasma.new

    expect(fantasma.soy_yo).to eq(fantasma)
  end

  it 'una clase que incorpora un trait no entiende los mensajes del algebra de traits' do
    class Fantasma
      uses MegaAtacante
    end

    fantasma = Fantasma.new

    expect(fantasma.respond_to?(:+)).to eq(false)

  end

  it 'una clase define un mensaje con el mismo nombre que el algebra de traits y el de la clase tiene prioridad' do
    class Fantasma
      uses MegaAtacante + Defensa

      def +
        "no soy la composicion de traits"
      end
    end

    fantasma = Fantasma.new

    expect(fantasma.+).to eq("no soy la composicion de traits")

  end

  it 'una trait no comprende los mensajes que se le definen' do
    expect(MegaAtacante.respond_to?(:danger)).to eq(false)
    expect(MegaAtacante.respond_to?(:ataque)).to eq(false)
  end

  it 'una clase no comprende los mensajes de un trait al usarlo' do
    clase_fantasma = Class.new{
      uses MegaAtacante
    }
    expect(clase_fantasma.respond_to?(:ataque)).to eq(false)
    expect(clase_fantasma.respond_to?(:danger)).to eq(false)
  end

  it 'la instancia de una clase comprende los mensajes de un trait que su clase incluyo' do
    clase_fantasma = Class.new{
      uses MegaAtacante
    }

    fantasma = clase_fantasma.new

    expect(fantasma.respond_to?(:ataque)).to eq(true)
    expect(fantasma.respond_to?(:danger)).to eq(true)
  end

end

describe 'tests respecto a la operacion + de trait' do

  it 'al sumar dos traits con conflicto de metodos se lanza una excepcion ' do

    expect{
    class Fantasma
      #comparten el metodo :ataque
      uses MegaAtacante + Ataque
    end
    }.to raise_error("Existen metodos en conflicto")
  end

  it 'se suma el mismo trait y no hay problemas de conflicto de mensajes' do
    class Fantasma
      uses Ataque + Ataque
    end

    fantasma = Fantasma.new

    expect(fantasma.ataque).to eq(0)
  end

  it 'se suma mas de dos traits juntos sin metodos conflictivos y la clase los incorpora' do
    class Fantasma
      uses MegaAtacante + Defensa + Espia
    end

    fantasma = Fantasma.new

    expect(fantasma.ataque).to eq(100)
    expect(fantasma.defensa).to eq(0)
    expect(fantasma.sigilo).to eq(200)

  end
end

describe 'tests respecto a la operacion - de trait' do

  it 'caso en el que le resto un metodo a un trait y no lo tiene mas' do
    trait_defensor = Defensa
    lista_de_metodos_sin_restar = trait_defensor.modulo.instance_methods
    expect(lista_de_metodos_sin_restar.size).to eq(2)
    expect((trait_defensor - :defensa).modulo.instance_methods.size).to eq(1)
  end

  it 'caso en el que le resto a un trait una lista de metodos' do
    trait_mega_atacante = MegaAtacante
    lista_de_metodos_sin_restar = trait_mega_atacante.modulo.instance_methods
    expect(lista_de_metodos_sin_restar.size).to eq(2)
    expect((trait_mega_atacante - lista_de_metodos_sin_restar).modulo.instance_methods.size).to eq(0)
  end

  it 'caso en el que se resta varios metodos encadenados' do
    trait Atacante do
      def defensa
        10
      end
      def ataque
        100
      end
    end
    trait_atacante = Atacante
    lista_de_metodos_sin_restar = trait_atacante.modulo.instance_methods
    expect((trait_atacante - :defensa - :ataque).modulo.instance_methods.size).to eq(0)
    expect(lista_de_metodos_sin_restar.size).to eq(2)
  end
end

describe 'tests respecto a la operacion << de trait' do

  it 'se decide ponerle un alias a un metodo del trait y cambia de nombre' do
    clase_de_prueba = Class.new do
      uses ((MegaAtacante << {ataque: :ataque_mega_atacante}) - :ataque)
      def ataque_nuevo
        ataque_mega_atacante
      end
    end
    objeto_de_prueba = clase_de_prueba.new
    expect(objeto_de_prueba.ataque_nuevo).to eq(100)
  end

  it 'se decide ponerle un alias a dos metodos de un trait y estos cambian de nombre' do
    clase_de_prueba = Class.new do
      uses ((MegaAtacante << {ataque: :ataque_mega_atacante, danger: :danger_mega_atacante}) - :ataque -:danger)
      def ataque_nuevo
        ataque_mega_atacante
      end
      def danger_nuevo
        danger_mega_atacante
      end
    end

    objeto_de_prueba = clase_de_prueba.new

    expect(objeto_de_prueba.ataque_nuevo).to eq(100)
    expect(objeto_de_prueba.danger_nuevo).to eq("Im the danger")
  end
end

