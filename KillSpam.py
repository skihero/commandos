from pybloomfilter import BloomFilter
import sys 
import logging

class SpamCheck (object): 
	def __init__(self):  
		# Setup the logging
	        self.ilog= logging.getLogger('prog')
		self.ilog.setLevel(logging.INFO)
	        self.console = logging.StreamHandler(sys.stderr)
	        self.console.setLevel(logging.INFO)
	        self.console.setFormatter(logging.Formatter('%(message)s'))
		self.ilog.addHandler(self.console)


		# Try loading the filter
	        try: 
	          self.__loadFilter__()
		  ilog.debug("loading filter.." ) 
		  
		# Create the filter if not present
		except: 
		       self.ilog.debug("Exception in loading ...." )
		       self.__create__()
		       self.ilog.debug("Creating the file ... ")

        def __loadFilter__(self): 
		self.bf = BloomFilter.open('filter.bloom')

	def __create__(self): 
		self.bf = BloomFilter(10000000, 0.01, 'filter.bloom')
		# Let us initalize the first time
		self.spam("000")
		# Generate the filter from a file
		with open("bad_numbers.txt") as f:
		    for nums in f:
		            self.bf.add(nums.rstrip())
			    self.ilog.debug(".")

	def spam(self, bad_entity): 
		with open("bad_numbers.txt","a+") as f: 
			f.write(bad_entity) 
			f.write("\n")
			self.ilog.info("Added bad entry to file")
		self.bf.add(bad_entity) 
		
	  	 
	def isSpam(self, entity): 
		return entity in self.bf 


	

if __name__ == "__main__":
   from KillSpam import SpamCheck 
   ks = SpamCheck()
   # This will add the spam to the filter
   ks.spam("abcd") 
  
   entitites = { "abcd", "def", "abcd" , "1234", "987"} 
	 
   for ent in entitites : 
   	print  (ent, ks.isSpam(ent) )
    

	



        
