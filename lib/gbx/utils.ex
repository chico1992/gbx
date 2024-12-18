defmodule Gbx.Utils do
  import Bitwise

  def getHeaderInfo(arr, data, 0) do
    {arr, data}
  end

  def getHeaderInfo(
        arr,
        <<class_id::binary-size(4), chunk_size::binary-size(4), rest::binary>>,
        counter
      ) do
    getHeaderInfo(
      [
        {class_id,
         Bitwise.band(:binary.decode_unsigned(chunk_size, :little), Bitwise.bnot(0x80000000))}
        | arr
      ],
      rest,
      counter - 1
    )
  end

  def getHeaderData(data, _, []) do
    data
  end

  def getHeaderData(data, bin, [{id, size} | tail]) do
    <<header_data::binary-size(size), rest::binary>> = bin
    getHeaderData([{id, size, header_data} | data], rest, tail)
  end

  def readLookBackString(
        {%{lookback_version: nil} = data, <<lbv::binary-size(4), bytes::binary>>},
        key
      ) do
    lookback_version = :binary.decode_unsigned(lbv, :little)
    readLookBackString({Map.put(data, :lookback_version, lookback_version), bytes}, key)
  end

  def readLookBackString(
        {data, <<i::binary-size(4), bytes::binary>>},
        key
      ) do
    index = :binary.decode_unsigned(i, :little)
    {string, rest} = readInternalString(index, bytes)
    {Map.put(data, key, string), rest}
  end

  def readString(
        {data, <<i::binary-size(4), bin::binary>>},
        key
      ) do
    index = :binary.decode_unsigned(i, :little)
    <<string::binary-size(index), bytes::binary>> = bin
    {Map.put(data, key, string), bytes}
  end

  def readUint32(
        {data, <<i::binary-size(4), bin::binary>>},
        key
      ) do
    index = :binary.decode_unsigned(i, :little)
    {Map.put(data, key, index), bin}
  end

  def readByte(
        {data, <<i::binary-size(1), bin::binary>>},
        key
      ) do
    index = :binary.decode_unsigned(i, :little)
    {Map.put(data, key, index), bin}
  end

  def readUnkown(
        {data, bin},
        size
      ) do
    <<_::binary-size(size), bytes::binary>> = bin
    {data, bytes}
  end

  defp readInternalString(index, bin) when index >>> 30 == 0 do
    {"Unknown Collection", bin}
  end

  defp readInternalString(_index, <<i::binary-size(4), bin::binary>>) do
    index = :binary.decode_unsigned(i, :little)
    <<string::binary-size(index), bytes::binary>> = bin
    {string, bytes}
  end
end
