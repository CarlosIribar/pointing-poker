defmodule PointerPoker.Pointer do
  def calc_mean(users) do
    total = Enum.reduce(users, 0, fn elem, acc -> acc + get_number(elem.point) end)
    len = length(users);
    dbg(len)
    div(total, if(len == 0, do: 1, else: len))
  end

  def calc_max(users) do
    Enum.reduce(
      users,
      0,
      fn elem, acc ->
        num = get_number(elem.point)
        if num > acc, do: num, else: acc
      end
    )
  end

  def calc_min(users) do
    Enum.reduce(
      users,
      21,
      fn elem, acc ->
        num = get_number(elem.point)
        if num < acc, do: num, else: acc
      end
    )
  end

  defp get_number(elem) do
    case elem do
      "?" -> 0
      _ -> String.to_integer(elem)
    end
  end
end
