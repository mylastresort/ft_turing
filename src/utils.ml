let str_pad_left str n c =
  let len = String.length str in
  if len > n then str
  else
    let space_len = n - len in
    Printf.sprintf "%s%s" str (String.make space_len c)

let rec pow base exp =
  match exp with 0 -> 1 | _ -> base * (pred exp |> pow base)

let rec factorial n =
  match n with x when x <= 1 -> 1 | x -> x * (pred x |> factorial)
