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

*)

let () =
	
	(* initiates Random *)
	Random.self_init () ;

	(* total is for counting the number of sucesses, stored as 
		a reference to count through the loop
	*)
	let total = ref 0. in
	(* defined number of trials *)
	let num_trials = 1000 in


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
;;