use "collections"

class Buffer
  let data: Array[U8]

  new create(size: USize = 0) =>
    data = Array[U8](0)

  new fromArray(data': Array[U8]) =>
    data = data'

  fun apply(i: USize)? : U8 =>
    data(i)?

  fun ref update(i: USize, value: U8)?: U8^ =>
    data(i) = value

  fun box compare(that: box->Buffer)? : I8 =>
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
      let i: USize = compare(that)?
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
      let i: USize = compare(that)?
      ((i == 0) or (i == 1))
    else
      false
    end

  fun size(): USize =>
    data.size()