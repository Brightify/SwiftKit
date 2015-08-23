# Changelog

## 0.5.5

Instances of a protocol `RequestEnhancer` now need to check for modifiers themselves. This also means that each registered `RequestEnhancer` will be asked if it can enhance a said request. Until now this would happen only if the request had at least one modifier.