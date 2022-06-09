from datetime import date


topay = open("topay.txt","r+")
topay_amount = topay.readline()

def numOfDays(date1, date2):
	return (date2-date1).days

date1= date.today()
date2 = date(2026, 7, 1)

quantum = numOfDays(date1, date2)
target = int(topay_amount) / quantum

print target
