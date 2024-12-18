defmodule Gbx do
  # <<0, 48, 4, 3>> -> 0x03043000
  def parse(
        <<"GBX", 6, 0, "BUCR", <<0, 48, 4, 3>>, _::binary-size(4), header_chunks::binary-size(4),
          rest::binary>>
      ) do
    count = header_chunks |> :binary.decode_unsigned(:little)
    {header_meta, bin} = Gbx.Utils.getHeaderInfo([], rest, count)

    Gbx.Utils.getHeaderData([], bin, header_meta |> Enum.reverse())
    |> Enum.reduce(Gbx.Map.new(), &Gbx.Map.parse/2)
  end

  # <<0, 48, 9, 3>> -> 0x03093000
  def parse(
        <<"GBX", 6, 0, "BUCR", <<0, 48, 9, 3>>, _::binary-size(4), header_chunks::binary-size(4),
          rest::binary>>
      ) do
    count = header_chunks |> :binary.decode_unsigned(:little)
    {header_meta, bin} = Gbx.Utils.getHeaderInfo([], rest, count)

    Gbx.Utils.getHeaderData([], bin, header_meta |> Enum.reverse())
    |> Enum.reduce(Gbx.Replay.new(), &Gbx.Replay.parse/2)
  end

  def parse(_) do
    {:error, "not a supported file"}
  end
end
