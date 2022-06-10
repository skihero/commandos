from datetime import date
import shelve

d = shelve.open("details")

def numOfDays(date1, date2):
	return (date2 - date1).days


target_amount = d["target_amount"]
target_date = d["target_date"]

date_today = date.today()

quantum = numOfDays(date_today, target_date)

target = int(target_amount) / quantum

print "Target per day:"
print target

print ""
print "Target Date:"
print target_date

print ""
print "Days till target:" 
print quantum 

print  ""
print "Target Amount:"
print target_amount
