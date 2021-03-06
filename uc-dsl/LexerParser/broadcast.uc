requires Broad.

direct bcDir {
  in pt1@bc_req(pl : port_list, u : univ)
  out bc_rsp(pt1 : port, u : univ)@pt2
}

direct BcDir {B : bcDir}

adversarial BcAdv {
  in bc_ok(pt2 : port)
  out bc_obs(pt1 : port, pl : port_list)
  out bc_req_err(pt1 : port, pl : port_list, pt2 :port)
}

functionality Forw() implements BcDir bcAdv {
  initial state Init {
    var bc_sent : port_list;
    match message with
      pt1@bc_req(pl, u) => {
        (* check that pt1 and all pl  don't point into forwarder or
           adversary *)
        if (envport(pt1) /\ envport(pl)) {
	send bc_obs(pt1, pl) and transition Wait(pt1, pl, bc_sent, u).
        }
        else { fail. }
      }
    | othermsg => { fail. }
    end
  }

  state Wait(pt1 : port, pl : port_list, bc_sent: port_list,  u : univ) {
    match message with
      bc_ok(pt2) => {
       if(is_in(pt2, bc_sent)){
        if(list_eq(bc_sent, pl)){
        send bc_rsp(pt1,u)@pt2 and transition Final().
        }
        else {
	      bc_sent <- list_cat(bc_sent, pt2);
	      send bc_rsp(pt1,u)@pt2 and transition Wait(pt1, pl, bc_sent, u).
	   }
       }
       else {
        send bc_req_err(pt1, pl, pt2) and
           transition Wait(pt1, pl, bc_sent, u).
       }
      }
    | othermsg => { fail. }
    end
  } 

  state Final() {
    match message with
     othermsg => { fail. }
    end
  }
}

