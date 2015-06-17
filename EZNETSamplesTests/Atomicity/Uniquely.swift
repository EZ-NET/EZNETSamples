//
//  Uniquely.swift
//  EZNETSamples
//
//  Created by Tomohiro Kumagai on H27/06/17.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import XCTest
import ESTestKit

class Uniquely: XCTestCase {
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	// MARK: [2.0 beta] isUniquelyReferenced は、ManagedBuffer などのあらかじめ用意された NonObjectiveCBase 準拠オブジェクトに対して使うようだ。
//	func testForSimpleObject_isUniquelyReferenced() {
//		
//		var object1:Object = Object()
//		var optional1:Object? = Object()
//		
//		
//		let isUnique1 = isUniquelyReferenced(&object1)
//		
//		var object2 = object1
//		var optional2 = optional1
//		
//		let isUnique2_1 = isUniquelyReferenced(&object1)
//		let isUnique2_2 = isUniquelyReferenced(&object2)
//
//		expected().success(isUnique1)
//		expected().success(isUnique2_1)
//		expected().success(isUnique2_2)
//	}

	func testForSimpleObject() {

		var object1:Object = Object()
		var optional1:Object? = Object()

		let isUniqueNonObjC1 = isUniquelyReferencedNonObjC(&object1)
		let isUniqueNonObjCOptional1 = isUniquelyReferencedNonObjC(&optional1)
		
		var object2 = object1
		var optional2 = optional1

		let isUniqueNonObjC2_1 = isUniquelyReferencedNonObjC(&object1)
		let isUniqueNonObjCOptional2_1 = isUniquelyReferencedNonObjC(&optional1)
		
		let isUniqueNonObjC2_2 = isUniquelyReferencedNonObjC(&object2)
		let isUniqueNonObjCOptional2_2 = isUniquelyReferencedNonObjC(&optional2)
		
		expected().success(isUniqueNonObjC1)
		unexpected().success(isUniqueNonObjC2_1)
		unexpected().success(isUniqueNonObjC2_2)

		expected().success(isUniqueNonObjCOptional1)
		unexpected().success(isUniqueNonObjCOptional2_1)
		unexpected().success(isUniqueNonObjCOptional2_2)
	}
	
	func testForSimpleSwiftyObjCClass() {
		
		// NSObject を継承しないクラスは Swift オブジェクトと同等の動きをするようだ。
		
		var object1:SwiftyObjCClass = SwiftyObjCClass()
		var optional1:SwiftyObjCClass? = SwiftyObjCClass()
		
		let isUniqueNonObjC1 = isUniquelyReferencedNonObjC(&object1)
		let isUniqueNonObjCOptional1 = isUniquelyReferencedNonObjC(&optional1)
		
		var object2 = object1
		var optional2 = optional1
		
		let isUniqueNonObjC2_1 = isUniquelyReferencedNonObjC(&object1)
		let isUniqueNonObjCOptional2_1 = isUniquelyReferencedNonObjC(&optional1)
		
		let isUniqueNonObjC2_2 = isUniquelyReferencedNonObjC(&object2)
		let isUniqueNonObjCOptional2_2 = isUniquelyReferencedNonObjC(&optional2)
		
		expected().success(isUniqueNonObjC1)
		unexpected().success(isUniqueNonObjC2_1)
		unexpected().success(isUniqueNonObjC2_2)
		
		expected().success(isUniqueNonObjCOptional1)
		unexpected().success(isUniqueNonObjCOptional2_1)
		unexpected().success(isUniqueNonObjCOptional2_2)
	}
	
	func testForSimplePureObjCClass() {
		
		// NSObject を継承ししたクラスは単一参照のときも検出できないようだ。
		
		var object1:PureObjCClass = PureObjCClass()
		var optional1:PureObjCClass? = PureObjCClass()
		
		let isUniqueNonObjC1 = isUniquelyReferencedNonObjC(&object1)
		let isUniqueNonObjCOptional1 = isUniquelyReferencedNonObjC(&optional1)
		
		var object2 = object1
		var optional2 = optional1
		
		let isUniqueNonObjC2_1 = isUniquelyReferencedNonObjC(&object1)
		let isUniqueNonObjCOptional2_1 = isUniquelyReferencedNonObjC(&optional1)
		
		let isUniqueNonObjC2_2 = isUniquelyReferencedNonObjC(&object2)
		let isUniqueNonObjCOptional2_2 = isUniquelyReferencedNonObjC(&optional2)
		
		unexpected("NSObject を継承したクラスでは単一参照を判定できない様子").success(isUniqueNonObjC1)
		unexpected().success(isUniqueNonObjC2_1)
		unexpected().success(isUniqueNonObjC2_2)
		
		unexpected("NSObject を継承したクラスでは単一参照を判定できない様子").success(isUniqueNonObjCOptional1)
		unexpected().success(isUniqueNonObjCOptional2_1)
		unexpected().success(isUniqueNonObjCOptional2_2)
	}
	
	func testForObjectInBoxClass() {
		
		// クラスなので let で良い
		let object1:BoxClass = BoxClass()
		let optional1:BoxClass? = BoxClass()
		
		let isUniqueNonObjC1 = isUniquelyReferencedNonObjC(&object1.object)
		
		// オプショナル内のオブジェクトを直接 optional1?.object のようには判定できない。
		let isUniqueNonObjCOptional1 = isUniquelyReferencedNonObjC(&optional1!.object)
		
		var object2 = object1.object
		var optional2 = optional1?.object
		
		let isUniqueNonObjC2_1 = isUniquelyReferencedNonObjC(&object1.object)
		let isUniqueNonObjCOptional2_1 = isUniquelyReferencedNonObjC(&optional1!.object)
		
		let isUniqueNonObjC2_2 = isUniquelyReferencedNonObjC(&object2)
		
		// オプショナル内のオブジェクトを var に取り出せば、それ自体は判定可能。
		let isUniqueNonObjCOptional2_2 = isUniquelyReferencedNonObjC(&optional2)
		
		expected().success(isUniqueNonObjC1)
		unexpected().success(isUniqueNonObjC2_1)
		unexpected().success(isUniqueNonObjC2_2)
		
		expected().success(isUniqueNonObjCOptional1)
		unexpected().success(isUniqueNonObjCOptional2_1)
		unexpected().success(isUniqueNonObjCOptional2_2)
	}
	
	func testForObjectInBoxStruct() {
		
		// 構造体なので var にしないと、メンバーを var で参照できない。
		var object1:BoxStruct = BoxStruct()
		var optional1:BoxStruct? = BoxStruct()
		
		let isUniqueNonObjC1 = isUniquelyReferencedNonObjC(&object1.object)
		
		// オプショナル内のオブジェクトを直接 optional1?.object のようには判定できない。
		let isUniqueNonObjCOptional1 = isUniquelyReferencedNonObjC(&optional1!.object)
		
		var object2 = object1.object
		var optional2 = optional1?.object
		
		let isUniqueNonObjC2_1 = isUniquelyReferencedNonObjC(&object1.object)
		let isUniqueNonObjCOptional2_1 = isUniquelyReferencedNonObjC(&optional1!.object)
		
		let isUniqueNonObjC2_2 = isUniquelyReferencedNonObjC(&object2)
		
		// オプショナル内のオブジェクトを var に取り出せば、それ自体は判定可能。
		let isUniqueNonObjCOptional2_2 = isUniquelyReferencedNonObjC(&optional2)
		
		expected().success(isUniqueNonObjC1)
		unexpected().success(isUniqueNonObjC2_1)
		unexpected().success(isUniqueNonObjC2_2)
		
		expected().success(isUniqueNonObjCOptional1)
		unexpected().success(isUniqueNonObjCOptional2_1)
		unexpected().success(isUniqueNonObjCOptional2_2)
	}

	func testForObjectInBoxClassContainer() {
		
		// クラスなので let で良い
		let object1:BoxClassContainer = BoxClassContainer()
		let optional1:BoxClassContainer? = BoxClassContainer()
		
		let isUniqueNonObjC1 = isUniquelyReferencedNonObjC(&object1.container.object)
		
		// オプショナル内のオブジェクトを直接 optional1?.object のようには判定できない。
		let isUniqueNonObjCOptional1 = isUniquelyReferencedNonObjC(&optional1!.container.object)
		
		var object2 = object1.container.object
		var optional2 = optional1?.container.object
		
		let isUniqueNonObjC2_1 = isUniquelyReferencedNonObjC(&object1.container.object)
		let isUniqueNonObjCOptional2_1 = isUniquelyReferencedNonObjC(&optional1!.container.object)
		
		let isUniqueNonObjC2_2 = isUniquelyReferencedNonObjC(&object2)
		
		// オプショナル内のオブジェクトを var に取り出せば、それ自体は判定可能。
		let isUniqueNonObjCOptional2_2 = isUniquelyReferencedNonObjC(&optional2)
		
		expected().success(isUniqueNonObjC1)
		unexpected().success(isUniqueNonObjC2_1)
		unexpected().success(isUniqueNonObjC2_2)
		
		expected().success(isUniqueNonObjCOptional1)
		unexpected().success(isUniqueNonObjCOptional2_1)
		unexpected().success(isUniqueNonObjCOptional2_2)
	}
	
	func testForObjectInBoxStructContainer() {
		
		// コンテナ自体はクラスなので var にしなくても、内部の構造体を var で参照できる。
		let object1:BoxStructContainer = BoxStructContainer()
		let optional1:BoxStructContainer? = BoxStructContainer()
		
		let isUniqueNonObjC1 = isUniquelyReferencedNonObjC(&object1.container.object)
		
		// オプショナル内のオブジェクトを直接 optional1?.object のようには判定できない。
		let isUniqueNonObjCOptional1 = isUniquelyReferencedNonObjC(&optional1!.container.object)
		
		var object2 = object1.container.object
		var optional2 = optional1?.container.object
		
		let isUniqueNonObjC2_1 = isUniquelyReferencedNonObjC(&object1.container.object)
		let isUniqueNonObjCOptional2_1 = isUniquelyReferencedNonObjC(&optional1!.container.object)
		
		let isUniqueNonObjC2_2 = isUniquelyReferencedNonObjC(&object2)
		
		// オプショナル内のオブジェクトを var に取り出せば、それ自体は判定可能。
		let isUniqueNonObjCOptional2_2 = isUniquelyReferencedNonObjC(&optional2)
		
		expected().success(isUniqueNonObjC1)
		unexpected().success(isUniqueNonObjC2_1)
		unexpected().success(isUniqueNonObjC2_2)
		
		expected().success(isUniqueNonObjCOptional1)
		unexpected().success(isUniqueNonObjCOptional2_1)
		unexpected().success(isUniqueNonObjCOptional2_2)
	}
}

extension Uniquely {
	
	class Object {
		
	}
	
	@objc class SwiftyObjCClass {
		
	}
	
	@objc class PureObjCClass : NSObject {
		
	}
	
	class BoxClassContainer {
	
		var container = BoxClass()
	}
	
	class BoxStructContainer {
		
		var container = BoxStruct()
	}
	
	class BoxClass {
		
		var object = Object()
	}
	
	struct BoxStruct {

		var object = Object()
	}
}