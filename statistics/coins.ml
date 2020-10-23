(* 
	Ryan Luk
	ryanluk4@gmail.com

	Basic coin flip, frequentist probabilty

	This will simulate flipping a coin via `Random.int 2` and print 
	the current frequentist probability every 10 trials, for `num_trials`.

	The frequentist probability is defined by the nature of inherently repeatable
	events, given by:

		P_f = lim (n -> inf) success / n

	This is a good way to estimate probability if the distribution is unknown.

	The probability bounces up and down as the number of trials increases and may
	deviate once hitting the expected value of 0.5, but the long run probability
	will match the expected value. 

	The expected probability of a fair coin flip can be achieved by counting the
	options H ot T. This can be labeled under the Pascal-Fermat definition of probability,
	given by: 

		P_{PF} = number of favorable outcomes / total number of outcomes

	The distribution for binary outcomes can be mapped to the Bernoulli distribution
	with probability density:

		P(X) = mu^x * (1 - mu)^{1-x} where P(X = 1) = mu and X in {0, 1}

	Mu is the probability of landing on X, either heads (0) or tails (1)

	For n > 1 trials, multiple by N nCr k (combinations)

*)

open! Owl

let monte_carlo _ = 

	(* initiates Random *)
	Random.self_init () ;

	Printf.printf "\nStarting Monte Carlo simulation...\n";

	(* total is for counting the number of sucesses, stored as 
		a reference to count through the loop
	*)
	let total = ref 0. in
	(* defined number of trials *)
	let num_trials = 1000 in

	(* running probability *)
	for i = 1 to num_trials do

		(* print out every 10 trials *)
		if (i mod 10) = 0 then
			Printf.printf "%f \n" (!total /. (float_of_int i))
		;
		
		(* simulates 50% success *)
		if Random.int 2 = 1 then
			(* sums total number of sucess through reference *)
			total := !total +. 1.
		;	

	done
	;

	print_endline "End of Monte Carlo simulation."

;;

let mc_binomial_dist _ =

	Printf.printf "\nStarting binomial distribution...\n" ;

	let total = ref 0. in
	let num_trials = 1000 in
	let prob_success = 0.3 in

	(* uses Stats module *)
	let flips = Array.make num_trials 0 in
  	let outcomes = Array.map (fun _ -> Stats.binomial_rvs ~p:prob_success ~n:1) flips in
  	outcomes |> Array.iter (fun x -> total := !total +. float_of_int x ; print_int x) ;
  	Printf.printf "\n" ;

  	(* total probability instead of rolling probability *)
  	Printf.printf "%f" (!total /. float_of_int num_trials) ;

  	Printf.printf "\nEnding binomial distribution\n"

;;

let binomial_pdf _ =

	Printf.printf "\nStarting binomial distribution PDF...\n" ;

	(* with given prob of success, give probability of recieving 'x' successes *)
	let prob_success = 0.3 in

	(* out of 'n' trials *)
	let choices = [|0;1;2;3|] in
	let outcomes = Array.map (Stats.binomial_pdf ~p:prob_success ~n:3) choices in
	outcomes |> Array.iteri (fun i x -> Printf.printf "%i : %f\n" i x);

	(* prints CDF of whole distribution = 1*)
	(* print_float (Array.fold_left (+.) 0. outcomes) ; *)

	Printf.printf "Ending binomial distribution PDF\n"

;;

let binomial_cdf _ =

	Printf.printf "\nStarting binomial distribution CDF...\n" ;

	let prob_success = 0.3 in

	(* gives CDF of above binomial dist. PDF *)
	(* CDF can also be easily derived by summing across PDF *)
	let choices = [|0;1;2;3|] in
	let outcomes = Array.map (Stats.binomial_cdf ~p:prob_success ~n:3) choices in
	outcomes |> Array.iteri (fun i x -> Printf.printf "%i : %f\n" i x);

	Printf.printf "Ending binomial distribution CDF\n"

;;

let _ = 
	monte_carlo () ;
	mc_binomial_dist () ;
	binomial_pdf () ;
	binomial_cdf () 