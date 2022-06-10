import shelve
d = shelve.open("details")

target_amount = d["target_amount"]


print "Enter earnings"
earnings = input()

print "Earlier target amount" 
print  target_amount 

print  ""
d["target_amount"] = target_amount - earnings

print "New target amount: " 

print d["target_amount"]

print "Execute quantum.py for target per day"
