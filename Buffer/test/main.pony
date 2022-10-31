use "pony_test"
use ".."

class iso _TestBuffer is UnitTest
  fun name(): String => "Testing Buffer"
  fun apply(t: TestHelper) =>
    let arr1: Array[U8] = [1;2;3;4;5;6]
    let arr2: Array[U8] = [1;2;3;4;5;6]
    let arr3: Array[U8] = [6;7;8;9;5;6]
    let arr4: Array[U8] = [1;1;1;1;1;1]
    let arr5: Array[U8] = [0;0;0;0;0;0]

    let buf1: Buffer = Buffer(arr1)
    let buf2: Buffer = Buffer(arr2)
    let buf3: Buffer = Buffer(arr3)
    let buf6: Buffer = Buffer(arr4)
    let buf7: Buffer = Buffer(arr5)
    try
      t.assert_true(buf1.compare(buf2)? == 0)
      t.assert_true(buf1.compare(buf3)? == -1)
      t.assert_true(buf3.compare(buf1)? == 1)

      t.assert_true(buf1 == buf2)
      t.assert_true(buf1 < buf3)
      t.assert_true(buf3 > buf1)
      var i: USize = buf1.size()
      buf1.append(buf2)
      t.assert_true(buf1.size() > i)
      var j: USize = 0
      while i < buf1.size() do
        t.assert_true((buf1(i = i + 1)? == buf2(j = j + 1)?))
      end
      let buf4: Buffer = buf1.slice(0, 4)
      t.assert_true(buf4(1)? == buf1(1)?)
      t.assert_true(buf4(3)? == buf1(3)?)
      let buf5: Buffer = buf2.clone()
      t.assert_true(buf5 == buf2)
      t.assert_false(buf5 is buf2)
      let buf8: Buffer = buf6 xor buf7
      t.assert_true(buf8 == buf6)
      let buf9: Buffer = Buffer([0;0;0;0;0;0])
      let buf10: Buffer = Buffer([1;1;1;1;1;1;1])
      let buf11: Buffer = buf9 and buf10
      let buf12: Buffer = buf9 or buf10
      let buf13: Buffer = Buffer([1;1;1;1;1;1])
      let buf14: Buffer =  not buf13
      t.log(buf14.string())
      t.assert_true(buf11 == buf9)
      t.assert_true(Buffer([254;254;254;254;254;254]) == buf14)
      let buf15 = Buffer([0;0;0;0])
      let buf16 = Buffer.init(4, 0)
      t.assert_true(buf15 == buf16)
    else
      t.fail("error")
    end

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)
  new make () =>
    None
  fun tag tests(test: PonyTest) =>
    test(_TestBuffer)
