(* Broad.ec *)
require import AllCore List.
type port.
type port_list =  port list.

print list.

  op is_in(x : port, ls : port_list) : bool = (x \in ls).

  op list_eq(x : port_list, y : port_list) : bool = (x=y).
  print insert.
  op list_cat(x : port_list, pt : port) : port_list = pt :: x.



qed.

  
