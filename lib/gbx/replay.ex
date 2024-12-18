defmodule Gbx.Replay do
  defstruct ~w[map_id map_collection map_author time player_nickname player_login title_id xml author_version author_login author_nickname author_zone author_extra_info challenge_data strings lookback_version gbx_version]a

  def new() do
    struct!(__MODULE__)
  end

  # <<0, 48, 9, 3>> -> 0x03093002
  def parse({<<2, 48, 9, 3>>, _, bytes}, %__MODULE__{} = replay) do
    {replay, bytes}
    |> Gbx.Utils.readUnkown(4)
    |> Gbx.Utils.readUint32(:author_version)
    |> Gbx.Utils.readString(:author_login)
    |> Gbx.Utils.readString(:author_nickname)
    |> Gbx.Utils.readString(:author_zone)
    |> Gbx.Utils.readString(:author_extra_info)
    |> elem(0)
  end

  # <<0, 48, 9, 3>> -> 0x03093001
  def parse({<<1, 48, 9, 3>>, _, bytes}, %__MODULE__{} = replay) do
    {replay, bytes}
    |> Gbx.Utils.readString(:xml)
    |> elem(0)
  end

  # <<0, 48, 9, 3>> -> 0x03093000
  def parse(
        {<<0, 48, 9, 3>>, _, <<_v::binary-size(4), bytes::binary>>},
        %__MODULE__{} = replay
      ) do
    # version = :binary.decode_unsigned(v, :little)

    {replay, bytes}
    |> Gbx.Utils.readLookBackString(:map_id)
    |> Gbx.Utils.readLookBackString(:map_collection)
    |> Gbx.Utils.readLookBackString(:map_author)
    |> Gbx.Utils.readUint32(:time)
    |> Gbx.Utils.readString(:player_nickname)
    |> Gbx.Utils.readString(:player_login)
    |> Gbx.Utils.readUnkown(1)
    |> Gbx.Utils.readLookBackString(:title_id)
    |> elem(0)
  end
end
