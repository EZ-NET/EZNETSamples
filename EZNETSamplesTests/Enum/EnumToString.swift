//
//  EnumToString.swift
//  EZNETSamples
//
//  Created by Tomohiro Kumagai on H27/06/18.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import XCTest
import ESTestKit
import SampleModuleA

public enum MyEnumToString {
	
	case Scene1
	case Scene2(String)
}

enum MyEnumToStringGeneric<T> {
	
	case Scene1
	case Scene2(T)
}


class EnumToString: XCTestCase {

	struct MyStruct {

	}
	
	struct MyStructWithValue {
	
		var value:Int
		
		init(_ value:Int) {
			
			self.value = value
		}
	}
	
	struct MyStructPrintable : CustomStringConvertible {
		
		var description:String {
			
			return "This is a MyStruct"
		}
	}
	
	struct MyStructWithValuePrintable : CustomStringConvertible {
		
		var value:Int
		
		init(_ value:Int) {
			
			self.value = value
		}
		
		var description:String {
			
			return "This is a MyStruct"
		}
	}
	
	enum MyLocalEnum {
		
		case Scene1
		case Scene2(MyStruct)
		case Scene3(MyStructWithValue)
		case Scene4(MyStructPrintable)
		
		// ❓ なぜか 5 つめの列挙子を追加したら、文字列化の際にどの列挙子も、列挙型までしか文字列化されなくなりました。
//		case Scene5(MyStructWithValuePrintable)
		
		// ❓ 値を取る列挙子で 4 つ以上の型を扱うとダメなのかもしれません。
//		case Scene6(NSError)
		
		// ❓ 値を取らない列挙子を増やした場合は大丈夫なようです。
		case Scene7
		
		// ❓ 既に使っている型の列挙子を増やす場合は大丈夫なようです。
		case Scene8(MyStructPrintable)
	}

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testToString() {

		let string1 = String(MyLocalEnum.Scene1)
		let string2 = String(MyEnumToString.Scene1)
		let string3 = String(SampleModuleA.MyEnum.Scene1)
		let string4 = String(MyEnum.Scene1)
		let string5 = String(MyEnumToString.Scene2("TEXT"))
		
		let case1 = MyLocalEnum.Scene1
		let case2 = MyEnumToString.Scene1
		let case3 = SampleModuleA.MyEnum.Scene1
		let case4 = MyEnum.Scene1
		let case5 = String(MyEnumToString.Scene2("TEXT"))

		let string1c = String(case1)
		let string2c = String(case2)
		let string3c = String(case3)
		let string4c = String(case4)
		let string5c = String(case5)
		
		// 文字列化したときには名前空間が付いて回ります。
		expected().equal(string1, "EZNETSamplesTests.EnumToString.MyLocalEnum.Scene1")
		expected().equal(string2, "EZNETSamplesTests.MyEnumToString.Scene1")
		expected().equal(string3, "SampleModuleA.MyEnum.Scene1")
		expected().equal(string4, "SampleModuleA.MyEnum.Scene1")
		expected().equal(string5, "EZNETSamplesTests.MyEnumToString.Scene2(\"TEXT\")")

		expected().equal(string1c, "EZNETSamplesTests.EnumToString.MyLocalEnum.Scene1")
		expected().equal(string2c, "EZNETSamplesTests.MyEnumToString.Scene1")
		expected().equal(string3c, "SampleModuleA.MyEnum.Scene1")
		expected().equal(string4c, "SampleModuleA.MyEnum.Scene1")
		expected().equal(string5c, "EZNETSamplesTests.MyEnumToString.Scene2(\"TEXT\")")

		expected().equal(string1, string1c)
		expected().equal(string2, string2c)
		expected().equal(string3, string3c)
		expected().equal(string4, string4c)
		expected().equal(string5, string5c)

		expected().equal(string2, string2c)
		expected().equal(string3, string3c)
		expected().equal(string4, string4c)
		expected().equal(string5, string5c)

		let va1 = String(MyLocalEnum.Scene2(MyStruct()))
		let va2 = String(MyLocalEnum.Scene3(MyStructWithValue(1)))
		let va3 = String(MyLocalEnum.Scene4(MyStructPrintable()))

		expected("値をともなわない構造体を入れてもその部分は可視化されません。").equal(va1, "EZNETSamplesTests.EnumToString.MyLocalEnum.Scene2")
		expected("値を伴う構造体ならそれも含めて可視化されます。").equal(va2, "EZNETSamplesTests.EnumToString.MyLocalEnum.Scene3(EZNETSamplesTests.EnumToString.MyStructWithValue(value: 1))")
		expected("値が Printable かで判断されている訳ではない様子です。").equal(va3, "EZNETSamplesTests.EnumToString.MyLocalEnum.Scene4")
		
		unexpected("もちろん列挙子の種類が違うので、添えた構造体が可視化されなくても、違う値として認識されます。").equal(va1, va3)
		
		let va4 = String(MyEnumToStringGeneric.Scene2(MyStruct()))
		let va5 = String(MyEnumToStringGeneric.Scene2(MyStructWithValue(1)))
		let va6 = String(MyEnumToStringGeneric.Scene2(MyStructPrintable()))

		expected("ジェネリックを扱う列挙型の場合、値をともなわない構造体を入れても可視化されるようです。").equal(va4, "EZNETSamplesTests.MyEnumToStringGeneric<EZNETSamplesTests.EnumToString.MyStruct>.Scene2(EZNETSamplesTests.EnumToString.MyStruct())")
		expected("値を伴う構造体ならそれも含めて可視化されます。").equal(va5, "EZNETSamplesTests.MyEnumToStringGeneric<EZNETSamplesTests.EnumToString.MyStructWithValue>.Scene2(EZNETSamplesTests.EnumToString.MyStructWithValue(value: 1))")
		expected("ジェネリックを扱う列挙型の場合、値の Printable が加味される様子です。").equal(va6, "EZNETSamplesTests.MyEnumToStringGeneric<EZNETSamplesTests.EnumToString.MyStructPrintable>.Scene2(This is a MyStruct)")
		
		unexpected("もちろん列挙子の種類が違うので、添えた構造体が可視化されなくても、違う値として認識されます。").equal(va4, va6)

//		let va7 = String(MyLocalEnum.Scene5(MyStructWithValuePrintable(1)))
		let va8 = String(MyEnumToStringGeneric.Scene2(MyStructWithValuePrintable(1)))
		let va9 = String(MyEnumToStringGeneric.Scene2(MyStructWithValuePrintable(2)))

//		expected("値を伴う構造体ならそれも含めて可視化されます。").equal(va7, "EZNETSamplesTests.MyEnumToStringGeneric<EZNETSamplesTests.EnumToString.MyStructWithValuePrintable>.Scene5(EZNETSamplesTests.EnumToString.MyStructWithValuePrintable(value: 1))")
		expected("ジェネリックを扱う列挙型の場合、値の Printable が加味される様子です。").equal(va8, "EZNETSamplesTests.MyEnumToStringGeneric<EZNETSamplesTests.EnumToString.MyStructWithValuePrintable>.Scene2(This is a MyStruct)")
		expected("つまり、異なる値で同じ description を返す場合、同じ列挙子と見なされてしまいます。").equal(va8, va9)
	}
}
