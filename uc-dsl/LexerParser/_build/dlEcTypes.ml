open DlParseTree
open DlTypes
open EcLocation

let checkNamedType (tyname:id) : typ =
	let tyn = unloc tyname in
	try ignore (List.find (fun tyn -> tyn=unloc tyname) builtinTypeNames); Tconstr (tyn,None)
	with Not_found ->
		if DlEcInterface.existsType tyn then Tconstr (tyn,None)
		else parse_error (loc tyname) (Some ("Non-existing type: "^(tyn)) )
let rec checkType (ty:ty) : typ =
	match ty with
	| NamedTy id -> checkNamedType id
	| TupleTy tl -> Ttuple (List.map (fun t ->checkType t) tl)
