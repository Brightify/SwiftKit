//
//  DeserializableDataTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 24.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble

class DeserializableDataTest: QuickSpec {
    
    override func spec() {
        describe("DeserializableData") {
            describe("get") {
                context("value is Deserializable") {
                    context("return type is optional") {
                        it("works with value") {
                            
                        }
                        it("works with array") {
                            
                        }
                        it("works with dictionary") {
                            
                        }
                        it("works with array with optionals") {
                            
                        }
                        it("works with dictionary with optionals") {
                            
                        }
                    }
                    context("default value provided") {
                        it("works with value") {
                            
                        }
                        it("works with array") {
                            
                        }
                        it("works with dictionary") {
                            
                        }
                        it("works with array with optionals") {
                            
                        }
                        it("works with dictionary with optionals") {
                            
                        }
                    }
                    context("can throws") {
                        it("works with value") {
                            
                        }
                        it("works with array") {
                            
                        }
                        it("works with dictionary") {
                            
                        }
                        it("works with array with optionals") {
                            
                        }
                        it("works with dictionary with optionals") {
                            
                        }
                    }
                }
                context("transformation provided") {
                    context("return type is optional") {
                        it("works with value") {
                            
                        }
                        it("works with array") {
                            
                        }
                        it("works with dictionary") {
                            
                        }
                        it("works with array with optionals") {
                            
                        }
                        it("works with dictionary with optionals") {
                            
                        }
                    }
                    context("default value provided") {
                        it("works with value") {
                            
                        }
                        it("works with array") {
                            
                        }
                        it("works with dictionary") {
                            
                        }
                        it("works with array with optionals") {
                            
                        }
                        it("works with dictionary with optionals") {
                            
                        }
                    }
                    context("can throws") {
                        it("works with value") {
                            
                        }
                        it("works with array") {
                            
                        }
                        it("works with dictionary") {
                            
                        }
                        it("works with array with optionals") {
                            
                        }
                        it("works with dictionary with optionals") {
                            
                        }
                    }
                }
                context("used polymorp") {
                    // TODO
                }
            }
            describe("subscript") {
                context("existing path") {
                    it("returns DeserializableData with subData") {
                        
                    }
                }
                context("nonexisting path") {
                    it("returns DeserializableData with .null") {
                        
                    }
                }
                it("accepts array") {
                    
                }
                it("accepts vararg") {
                    
                }
            }
            describe("deserialize") {
                context("correct value") {
                    it("returns value") {
                        
                    }
                }
                context("incorrect value") {
                    it("returns nil") {
                        
                    }
                }
                context("value is polymorphic") {
                    it("returns value") {
                        
                    }
                }
            }
            describe("valueOrThrow") {
                context("value is present") {
                    it("returns value") {
                        
                    }
                }
                context("value is nil") {
                    it("throws error") {
                        
                    }
                }
            }
        }
    }
}
