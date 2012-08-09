import logging 

def main(): 
	logging.basicConfig(format=("%(asctime).19s %(levelname)s %(filename)s:" "%(lineno)s %(message)s "))
	color_red = '\x1b[31m'
	color_normal = '\x1b[0m'
	color_yellow  = '\x1b[33m'

	for i in range (1,1000): 
		if i % 2 == 0  : 
			logging.getLogger().setLevel(logging.INFO)
			logging.info("Even %s %s %s", color_red , i, color_normal ) 

		else: 
			logging.getLogger().setLevel(logging.DEBUG)
			logging.debug("Odd %s %s %s ", color_yellow, i , color_normal ) 


if __name__=="__main__":
	main()
