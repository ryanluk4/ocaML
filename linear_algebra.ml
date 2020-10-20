(*
	Ryan Luk
	ryanluk4@gmail.com

	Linear algebra module from Owl

*)

(* types of matrices
	Mat.empty 5 5;;        (* create a 5 x 5 matrix with initialising elements *)
	Mat.create 5 5 2.;;    (* create a 5 x 5 matrix and initialise all to 2. *)
	Mat.zeros 5 5;;        (* create a 5 x 5 matrix of all zeros *)
	Mat.ones 5 5;;         (* create a 5 x 5 matrix of all ones *)
	Mat.eye 5;;            (* create a 5 x 5 identity matrix *)
	Mat.uniform 5 5;       (* create a 5 x 5 random matrix of uniform distribution *)
	Mat.uniform_int 5 5;;  (* create a 5 x 5 random integer matrix *)
	Mat.sequential 5 5;;   (* create a 5 x 5 matrix of sequential integers *)
	Mat.semidef 5;;        (* create a 5 x 5 random semi-definite matrix *)
	Mat.gaussian 5 5;;     (* create a 5 x 5 random Gaussian matrix *)
	Mat.bernoulli 5 5      (* create a 5 x 5 random Bernoulli  matrix *)
*)

(* print matrix
	Mat.(matrix |> print)
*)

(* interation 
	Mat.iteri_2d (fun i j a -> Printf.printf "(%i,%i) %.1f\n" i j a) x;; 
*)

(* produces identity matrix
	Mat.(matrix *@ inverse |> print) 
*)

open! Owl

(* rank of matrix *)
let rank matrix =
	let r = Linalg.D.rank matrix in
	Printf.printf "\nthe rank of this matrix is %i\n" r

(* det of matrix *)
let determinant matrix = 
	let d = Linalg.D.det matrix in
	Printf.printf "\nthe determinant of this matrix is %f\n" d

(* inverse matrix *)
let inverse matrix =
	Printf.printf "\nthe inverse of this matrix is";
	let i = Linalg.D.inv matrix in
	Mat.(i |> print)

let () = 
	Printf.printf "\nthe original matrix is\n";
	let matrix = Mat.uniform 3 3 in
	Mat.(matrix |> print);
	rank matrix;
	determinant matrix;
	inverse matrix