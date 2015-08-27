# Changelog

## 0.5.7

* Add `allowUnboundFactories` variable into DI `Module` to make mocking easier. This means that if your code heavily uses factories, you will not need to bind each type. Instead you can just override the varibable and return `true` to inform the Injector that you do not care about the injection-time safety for factories. This does not change the behavior of instance injection.

## 0.5.6

* Remove forgotten `println` in `ModuleBuilder`.

## 0.5.5

* Instances of a protocol `RequestEnhancer` now need to check for modifiers themselves. This also means that each registered `RequestEnhancer` will be asked if it can enhance a said request. Until now this would happen only if the request had at least one modifier.