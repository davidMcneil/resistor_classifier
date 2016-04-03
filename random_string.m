
function randString = random_string()
	s = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
	%find number of random characters to choose from
	numRands = length(s); 
	%specify length of random string to generate
	sLength = 10;
	%generate random string
	randString = s(ceil(rand(1,sLength)*numRands));
end
