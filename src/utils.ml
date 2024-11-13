let str_pad_left str n c =
  let space_len = n - String.length str in
  Printf.sprintf "%s%s" str (String.make space_len c)
