use @ponyint_hash_block[USize](ptr: Pointer[None] tag, size: USize)
use @ponyint_hash_block64[U64](ptr: Pointer[None] tag, size: USize)
use "collections"

primitive CopyBufferRange
  fun apply(buf: Buffer box, from: USize = 0, to: USize = -1): Buffer iso^ =>
    let copied: Buffer iso = recover Buffer(if to > buf.size() then buf.size() - from else to -from end) end
    for byte in Range(from, to) do
      try
        copied.push(buf(byte)?)
      else
        break
      end
    end
    consume copied

class Buffer
  let data: Array[U8]

  new create(data': (Array[U8] | USize) = Array[U8](0)) =>
    data = match data'
      | let data'': Array[U8] =>
        data''
      | let size': USize =>
        Array[U8](size')
    end
  new val fromArray(data': Array[U8] val) =>
    data = Array[U8](data'.size())
    data'.copy_to(data,0,0,data'.size())

  fun apply(i: USize) : U8 ? =>
    data(i)?

  fun hash(): USize =>
    @ponyint_hash_block(data.cpointer(), data.size())

  fun hash64(): U64 =>
     @ponyint_hash_block64(data.cpointer(), data.size())

  fun ref update(i: USize, value: U8): U8^ ? =>
    data(i)? = value

  fun ref append(that: Buffer box, offset: USize val = 0, len: USize val = -1) =>
    data.append(that.data, offset, len)

  fun ref push(value: U8) =>
    data.push(value)

  fun ref pop(): U8^ ? =>
    data.pop()?

  fun ref unshift(value: U8) =>
    data.unshift(value)

  fun ref shift(): U8 ? =>
    data.shift()?

  fun ref reserve(len: USize) =>
    data.reserve(len)

  fun slice(from: USize = 0, to: USize = -1, step: USize = 1): Buffer iso^ =>
    let buf = recover Buffer end
    let slice' = data.slice(from, to, step)
    buf.reserve(slice'.size())
    for i in slice'.values() do
      buf.push(i)
    end
    consume buf


  fun clone(): Buffer iso^ =>
    let buf = recover Buffer end
    for i in data.values() do
      buf.push(i)
    end
    consume buf

  fun box compare(that: box->Buffer): I8 ? =>
    let length: USize = if that.size() > size() then size() else that.size() end
    var a: USize = size()
    var b: USize = that.size()

    for i in Range(0, length) do
      if data(i)? != that.data(i)? then
        a = data(i)?.usize()
        b = that.data(i)?.usize()
        break
      end
    end

    if a > b then
      1
    elseif b > a then
      -1
    else
      0
    end

  fun box eq(that: box->Buffer): Bool =>
    try
      compare(that)? == 0
    else
      false
    end

  fun box ne(that: box->Buffer): Bool =>
    not eq(that)

  fun box gt (that: box->Buffer): Bool =>
    try
      compare(that)? == 1
    else
      false
    end

  fun box ge (that: box->Buffer): Bool =>
    try
      let i: I8 = compare(that)?
      ((i == 0) or (i == 1))
    else
      false
    end

  fun box lt (that: box->Buffer): Bool =>
    try
      compare(that)? == -1
    else
      false
    end

  fun box le (that: box->Buffer): Bool =>
    try
      let i: I8 = compare(that)?
      ((i == 0) or (i == 1))
    else
      false
    end

  fun box op_xor (that: box->Buffer): Buffer iso^ =>
    let len: USize = if data.size() < that.data.size() then data.size() else that.data.size() end
    let data': Array[U8] iso = recover Array[U8](len) end
    for i in Range(0, len) do
      data'.push(try data(i)? else U8(0) end xor try that.data(i)? else U8(0) end)
    end
    recover Buffer(consume data') end

  fun box op_and (that: box->Buffer): Buffer iso^  =>
    let len: USize = if data.size() < that.data.size() then data.size() else that.data.size() end
    let data': Array[U8] iso = recover Array[U8](len) end
    for i in Range(0, len) do
      data'.push(try data(i)? else U8(0) end and try that.data(i)? else U8(0) end)
    end
    recover Buffer(consume data') end

  fun box op_or (that: box->Buffer): Buffer iso^  =>
    let len: USize = if data.size() < that.data.size() then data.size() else that.data.size() end
    let data': Array[U8] iso = recover Array[U8](len) end
    for i in Range(0, len) do
      data'.push(try data(i)? else U8(0) end or try that.data(i)? else U8(0) end)
    end
    recover Buffer(consume data') end

  fun box op_not (): Buffer iso^  =>
    let len: USize = data.size()
    let data': Array[U8] iso = recover Array[U8](len) end
    for i in data.values() do
      data'.push(not i)
    end
    recover Buffer(consume data') end

  fun box values() : ArrayValues[U8, this->Array[U8 val]]^ =>
    data.values()

  fun box size(): USize =>
    data.size()

  fun ref compact() =>
    data.compact()

  fun string() : String =>
    let len: USize = data.size()
    let str: String iso = recover String(len * 2) end
    for i in data.values() do
      str.append(i.string())
      str.append(",")
    end
    if data.size() > 0 then
      str.delete(data.size().isize() - 1)
    end
    consume str
