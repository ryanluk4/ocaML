(*
	Ryan Luk
	ryanluk4@gmail.com

	Gradient descent algorithm to find local minimum

*)

open Owl
open Algodiff.D

let rec gradient_desc ?(eta=F 0.01) ?(eps=1e-6) f x =
  let g = (diff f) x in (* differentiation of function, plug in x *)
  if (unpack_flt g) < eps then x (* if the change is less than eps *)
  else desc ~eta ~eps f Maths.(x - eta * g) (* iterations *)


let _ =
  let f = Maths.sin in (* original function *)
  let y = gradient_desc f (F (Stats.std_uniform_rvs ())) in (* random var starting *)
  Owl_log.info "argmin f(x) = %g" (unpack_flt y)