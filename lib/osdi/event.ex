defmodule Osdi.Event do
  def from_nb(event) do
    event
    |> to_atom_map()
    |> Transformers.Nb.Event.to_map()
  end

  def  convert_to_atom_map(map), do: to_atom_map(map)
  defp to_atom_map(map) when is_map(map), do: Map.new(map, fn {k, v} -> {String.to_atom(k), to_atom_map(v)} end)
  defp to_atom_map(v), do: v

  def add_date_line(event) do
    date_line =
      humanize_date(event.start_date, event.time_zone) <> "from " <>
      humanize_time(event.start_date, event.time_zone) <> " - " <>
      humanize_time(event.end_date, event.time_zone)

    Map.put(event, :date_line, date_line)
  end

  defp humanize_date(iso_string, time_zone) do
    %DateTime{month: month, day: day} = get_zoned_dt(iso_string, time_zone)

    month = ["January", "February", "March", "April", "May", "June", "July",
             "August", "September", "October", "November", "December"] |> Enum.at(month - 1)

    "#{month}, #{day} "
  end

  defp humanize_time(iso_string, time_zone) do
    %DateTime{hour: hour, minute: minute} = get_zoned_dt(iso_string, time_zone)


    {hour, am_pm} = if hour >= 12, do: {hour - 12, "PM"}, else: {hour, "AM"}
    hour = if hour == 0, do: 12, else: hour
    minute = if minute == 0, do: "", else: ": #{minute}"

    "#{hour}#{minute} " <> am_pm
  end

  defp get_zoned_dt(iso_string, time_zone) do
    {:ok, %{month: month, day: day, year: year, minute: minute, hour: hour}, offset} = DateTime.from_iso8601(iso_string)

    Timex.Timezone.convert(
      %DateTime{month: month, day: day, year: year, utc_offset: 0,
                hour: hour, minute: minute, second: 0, time_zone: "",
                zone_abbr: "", std_offset: 0},
      time_zone |> official_from_nb() |> Timex.Timezone.get(Timex.now())
    )
  end

  defp official_from_nb("Pacific Time (US & Canada)"), do: "America/Los_Angeles"
  defp official_from_nb("Mountain Time (US & Canada)"), do: "America/Phoenix"
  defp official_from_nb("Central Time (US & Canada)"), do: "America/Chicago"
  defp official_from_nb("Eastern Time (US & Canada)"), do: "America/New_York"

end
