Dig IPs
=======


Usage:  
-----------
	dout domain host_pattern 

How it works: 
-------------- 

The script does a dig for the machines with host pattern and 
the domain name. 


The host pattern now is a substring, that will be expanded 
to substring1,..,..,substringN.  These are collected in a 
file and processed using dig. 

eg. 
	dout domain   web mail chat 
	
will generate internally 

 	web1.domain.com
	web2.domain.com
	web3.domain.com

	mail1.domain.com
	mail2.domain.com

	chat1.domain.com
	chat2.domain.com
	.....

and their corresponding Dig answers will be recorded 
in a separate file 





