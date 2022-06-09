import sys


days_earning = sys.argv[1]	

topay = open("topay.txt","r+")
topay_amount = topay.readline()

new_topay_amount = int(topay_amount) - int(days_earning)
print new_topay_amount

topay = open("topay.txt", "w")
topay.write(str(new_topay_amount))
print new_topay_amount
topay.close()

