# Changelog

## 1.0.0 [next release]

* Migrated to Swift 2.0.
* Added `Serializable` and `Deserializable` to allow single-way mapping.
* Added releasing of an initialization closure bound as a singleton when the object is first injected.
* Removed @objc annotation that was previously required for polymorphic object mapping.

## 0.5.10

* Added a method `resolveEndpointUrl` into `Router` to let users get the full URL of an endpoint.

## 0.5.9

* Added support for absolute urls in endpoints.

## 0.5.8

* Added event relaying methods to `Event` class and `map` methods to `EventData` struct.

## 0.5.7

* Added `allowUnboundFactories` variable into DI `Module` to make mocking easier. This means that if your code heavily uses factories, you will not need to bind each type. Instead you can just override the varibable and return `true` to inform the Injector that you do not care about the injection-time safety for factories. This does not change the behavior of instance injection.

## 0.5.6

* Removed forgotten `println` in `ModuleBuilder`.

## 0.5.5

* Instances of a protocol `RequestEnhancer` now need to check for modifiers themselves. This also means that each registered `RequestEnhancer` will be asked if it can enhance a said request. Until now this would happen only if the request had at least one modifier.