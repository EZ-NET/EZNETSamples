//
//  ConvertToArrayTests.swift
//  EZNETSamples
//
//  Created by Tomohiro Kumagai on H27/06/21.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import XCTest
import ESTestKit

class ConvertToArrayTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConvertToArray() {

		func reinterpret<R>(p:UnsafePointer<Void>) -> UnsafePointer<R> {
			
			return UnsafePointer<R>(p)
		}
		
		func countOfUniformTuple<Tuple,U>(p:Tuple, withType type:U.Type) -> Int {
			
			let nativeSize = sizeof(Tuple)
			let asTypeSize = sizeof(type)
			
			guard nativeSize % asTypeSize == 0 else {
			
				fatalError("Invalid arguments.")
			}
			
			return nativeSize / asTypeSize
		}
		
		var tuple:(Int32, Int32, Int32, Int32) = (1, 8, 30, 100)
		
		let size = countOfUniformTuple(tuple, withType: Int32.self)
		let p = reinterpret(&tuple) as UnsafePointer<Int32>

		expected().equal(size, 4)
		unexpected().equal(size, 0)
		
		let buffer = UnsafeBufferPointer(start: p, count: size)
		let array = Array<Int32>(buffer)
		
		expected().equal(array, Array<Int32>(arrayLiteral: 1, 8, 30, 100))
	}
}
