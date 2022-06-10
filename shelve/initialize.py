from datetime import date
import shelve

d = shelve.open("details") 
print "Enter target amount for initialization"

d["target_amount"]=input()
print ""

print "Target amount initialized"
print d["target_amount"]


print ""
print "Enter target year:" 
tyear = int(input())

print "Enter target month:"
tmonth = int(input())

print "Enter target Date:" 
tdate = int(input())


d["target_date"] = date(tyear, tmonth, tdate) 

print ""
print "Target date initialized"
print d["target_date"] 



