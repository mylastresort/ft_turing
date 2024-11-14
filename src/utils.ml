let str_pad_left str n c =
  let len = String.length str in
  if len > n then str
  else
    let space_len = n - len in
    Printf.sprintf "%s%s" str (String.make space_len c)
