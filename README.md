## Primer Tp realizado en la cursada de Objetos III en la UNQ en el segundo cuatrimestre de 2020

# Template de Proyecto Ruby para Objetos 3 (UNQ)

![Alt text](https://i.redd.it/0lfad3e7x4o51.png) 


## Setup

La primera vez que clonen el repositorio deberan instalar las dependencias que ya tenemos definidas en Gemfile (rspec), para esto tienen que tener instalado `ruby` y `bundler`.

Checkear que tengo Ruby

```bash
ruby -v
> ruby 2.7.1p83 (2020-03-31 revision a0c7c23c9c) [x86_64-linux]
```

Checkear que tengo Bundler

```bash
bundle -v
> Bundler version 2.1.4
```

Ahora sí, instalamos con

```bash
bundle install
```

## Ejectuar los tests

Desde consola

```bash
bundle exec rspec spec
```

