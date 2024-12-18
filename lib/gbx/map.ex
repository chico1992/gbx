defmodule Gbx.Map do
  defstruct ~w[map_id map_collection map_author map_name map_kind bronze_time silver_time gold_time author_time cost is_lap_race is_multilap play_mode author_score editor_mode nb_checkpoints nb_laps xml author_version author_login author_nickname author_zone author_extra_info lookback_version decoration_id decoration_collection decoration_author]a

  def new() do
    struct!(__MODULE__)
  end

  # <<2, 48, 4, 3>> -> 0x03043002
  def parse(
        {<<2, 48, 4, 3>>, _, <<_v::binary-size(1), bytes::binary>>},
        %__MODULE__{} = map
      ) do
    # TODO: handel versions correctly
    {map, bytes}
    |> Gbx.Utils.readUnkown(4)
    |> Gbx.Utils.readUint32(:bronze_time)
    |> Gbx.Utils.readUint32(:silver_time)
    |> Gbx.Utils.readUint32(:gold_time)
    |> Gbx.Utils.readUint32(:author_time)
    |> Gbx.Utils.readUint32(:cost)
    |> Gbx.Utils.readUint32(:is_lap_race)
    |> Gbx.Utils.readUint32(:is_multilap)
    |> Gbx.Utils.readUint32(:play_mode)
    |> Gbx.Utils.readUnkown(4)
    |> Gbx.Utils.readUint32(:author_score)
    |> Gbx.Utils.readUint32(:editor_mode)
    |> Gbx.Utils.readUnkown(4)
    |> elem(0)
  end

  # <<3, 48, 4, 3>> -> 0x03043003
  def parse(
        {<<3, 48, 4, 3>>, _, <<_v::binary-size(1), bytes::binary>>},
        %__MODULE__{} = map
      ) do
    {map, bytes}
    |> Gbx.Utils.readLookBackString(:map_id)
    |> Gbx.Utils.readLookBackString(:map_collection)
    |> Gbx.Utils.readLookBackString(:map_author)
    |> Gbx.Utils.readString(:map_name)
    |> Gbx.Utils.readByte(:map_kind)
    |> Gbx.Utils.readUnkown(4)
    |> Gbx.Utils.readString(:password)
    |> Gbx.Utils.readLookBackString(:decoration_id)
    |> Gbx.Utils.readLookBackString(:decoration_collection)
    |> Gbx.Utils.readLookBackString(:decoration_author)
    |> Gbx.Utils.readUnkown(8)
    |> Gbx.Utils.readUnkown(8)
    |> elem(0)
  end

  # <<4, 48, 4, 3>> -> 0x03043004
  def parse(
        {<<4, 48, 4, 3>>, _, _},
        %__MODULE__{} = map
      ) do
    map
  end

  # <<5, 48, 4, 3>> -> 0x03043005
  def parse({<<5, 48, 4, 3>>, _, bytes}, %__MODULE__{} = map) do
    {map, bytes}
    |> Gbx.Utils.readString(:xml)
    |> elem(0)
  end

  # <<7, 48, 4, 3>> -> 0x03043007
  def parse(
        {<<7, 48, 4, 3>>, _, <<_v::binary-size(4), _bytes::binary>>},
        %__MODULE__{} = map
      ) do
    # todo get thumbnail
    map
  end

  # <<8, 48, 4, 3>> -> 0x03043007
  def parse(
        {<<8, 48, 4, 3>>, _, <<_v::binary-size(4), bytes::binary>>},
        %__MODULE__{} = map
      ) do
    {map, bytes}
    |> Gbx.Utils.readUint32(:author_version)
    |> Gbx.Utils.readString(:author_login)
    |> Gbx.Utils.readString(:author_nickname)
    |> Gbx.Utils.readString(:author_zone)
    |> Gbx.Utils.readString(:author_extra_info)
    |> elem(0)
  end
end
