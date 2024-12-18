# Gbx

this is a partial implementation of a GBX parser for Trackmania

## Usage

```elixir
{:ok, file} = File.read("replay or map file")
Gbx.parse(file)
```

## Credits

Thanks to [gbx-ts](https://github.com/thaumictom/gbx-ts) which was used as a reference for this implementation
