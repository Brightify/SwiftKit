//
//  StyleKitMatchingTest.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 07/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

import Quick
import Nimble
@testable import SwiftKit

protocol MockStyleable: Styleable {
    var parentMock: MockStyleable? { get set }
    
    var mockChildren: [MockStyleable] { get set }
    
    var styleIndices: [Int] { get }
    
    func addChild(child: MockStyleable)
    
    func removeFromParent()
    
    func styled(index: Int)
}

extension MockStyleable {
    var styledTimes: Int {
        return styleIndices.count
    }
    
    func styleChildren(manager: StyleManager) {
        children.forEach { manager.apply($0) }
    }
}

class BaseMockStyleable: MockStyleable {
    lazy var stylingHandler: StylingHandler = StylingHandler(styledItem: self)
    
    var parent: Styleable? {
        return parentMock
    }
    
    var children: [Styleable] {
        return mockChildren.map { $0 }
    }
    
    var parentMock: MockStyleable?
    
    var mockChildren: [MockStyleable] = []
    
    var styleIndices: [Int] = []
    
    func addChild(child: MockStyleable) {
        precondition(child.parent == nil, "Child cannot have a parent")
        
        child.parentMock = self
        mockChildren.append(child)
    }
    
    func removeFromParent() {
        if let index = parentMock?.children.indexOf({ $0 === self }) {
            parentMock?.mockChildren.removeAtIndex(index)
        }
        parentMock = nil
    }
    
    func styled(index: Int) {
        styleIndices.append(index)
    }
    
    static func style(index: Int = 0)(item: MockStyleable) {
        item.styled(index)
    }
}

class ChildAMockStyleable: BaseMockStyleable { }

class ChildBMockStyleable: BaseMockStyleable { }

class StyleKitMatchingTest: QuickSpec {
    override func spec() {
        describe("StyleKit matching") {
            
            it("matches single item with or without name") {
                // given
                let styles = StyleManager { declare in
                    declare.style(BaseMockStyleable.self, styling: BaseMockStyleable.style())
                }
                let item = BaseMockStyleable()
                let namedItem = BaseMockStyleable()
                namedItem.names = ["hello"]
  
                // when
                styles.apply(item)
                styles.apply(namedItem)
                
                // then
                expect(item.styledTimes) == 1
                expect(namedItem.styledTimes) == 1
            }
            
            it("matches single named item and ignores unnamed") {
                // given
                let styles = StyleManager { declare in
                    declare.style(BaseMockStyleable.self, named: "hello", styling: BaseMockStyleable.style())
                }
                let item = BaseMockStyleable()
                let namedItem = BaseMockStyleable()
                namedItem.names = ["hello"]
                
                // when
                styles.apply(item)
                styles.apply(namedItem)
                
                // then
                expect(item.styledTimes) == 0
                expect(namedItem.styledTimes) == 1
            }
            
            it("matches item noncanonical subclasses") {
                // given
                let styles = StyleManager { declare in
                    declare.style(BaseMockStyleable.self, styling: BaseMockStyleable.style())
                }
                let base = BaseMockStyleable()
                let childA = ChildAMockStyleable()
                let childB = ChildBMockStyleable()
                
                // when
                styles.apply(base)
                styles.apply(childA)
                styles.apply(childB)
                
                // then
                expect(base.styledTimes) == 1
                expect(childA.styledTimes) == 1
                expect(childB.styledTimes) == 1
            }
            
            it("matches item noncanonical subclasses but not canonical") {
                // given
                let styles = StyleManager { declare in
                    declare.style(BaseMockStyleable.self, styling: BaseMockStyleable.style(1))
                    declare.style(ChildAMockStyleable.self, styling: BaseMockStyleable.style(2))
                }
                let base = BaseMockStyleable()
                let childA = ChildAMockStyleable()
                let childB = ChildBMockStyleable()
                
                // when
                styles.apply(base)
                styles.apply(childA)
                styles.apply(childB)
                
                // then
                expect(base.styledTimes) == 1
                expect(childA.styledTimes) == 1
                expect(childB.styledTimes) == 1
                
                expect(base.styleIndices) == [1]
                expect(childA.styleIndices) == [2]
                expect(childB.styleIndices) == [1]
            }
            
            it("matches item inside parent") {
                // given
                let styles = StyleManager { declare in
                    declare.inside(BaseMockStyleable).style(BaseMockStyleable.self, styling: BaseMockStyleable.style())
                }
                let parent = BaseMockStyleable()
                let child = BaseMockStyleable()
                parent.addChild(child)
                let independent = BaseMockStyleable()
                
                // when
                styles.apply(parent, includeChildren: false)
                styles.apply(child, includeChildren: false)
                styles.apply(independent, includeChildren: false)
                
                // then
                expect(parent.styledTimes) == 0
                expect(child.styledTimes) == 1
                expect(independent.styledTimes) == 0
            }
            
            it("matches item inside parent subtype") {
                // given
                let styles = StyleManager { declare in
                    declare.inside(BaseMockStyleable).style(BaseMockStyleable.self, styling: BaseMockStyleable.style(1))
                    declare.style(ChildAMockStyleable.self, styling: BaseMockStyleable.style(2))
                }
                let parent = ChildAMockStyleable()
                let child = BaseMockStyleable()
                parent.addChild(child)
                let independent = BaseMockStyleable()
                
                // when
                styles.apply(parent, includeChildren: false)
                styles.apply(child, includeChildren: false)
                styles.apply(independent, includeChildren: false)
                
                // then
                expect(parent.styledTimes) == 1
                expect(child.styledTimes) == 1
                expect(independent.styledTimes) == 0
                
                expect(parent.styleIndices) == [2]
                expect(child.styleIndices) == [1]
                expect(independent.styleIndices) == []
            }
        }

    }
}