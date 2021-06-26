use "ponytest"
use ".."

class iso _TestBuffer is UnitTest
  fun name(): String => "Testing Buffer"
  fun apply(t: TestHelper) =>
    let arr1: Array[U8] = [1;2;3;4;5;6]
    let arr2: Array[U8] = [1;2;3;4;5;6]
    let arr3: Array[U8] = [6;7;8;9;5;6]

    let buf1: Buffer = Buffer(arr1)
    let buf2: Buffer = Buffer(arr2)
    let buf3: Buffer = Buffer(arr3)
    try
      t.log(buf1.compare(buf2)?.string())
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
      let buf4 = buf1.slice(0, 4)
      t.assert_true(buf4(1)? == buf1(1)?)
      t.assert_true(buf4(3)? == buf1(3)?)
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
