[kishore@sa-kishore-k ~/haproxy_stuff]$ cat test_db.py 
#!/usr/bin/python

import MySQLdb
import random
import cgi
import cgitb 

def createDefCon():
 try:
	host = "deimos"
 	port = 3306        
 	user = "kish"      
 	passwd = "deimos"   
	db = "wikipedia"  
 	 
 	con = MySQLdb.connect(host = host, port = port , user = user, passwd = passwd, db = db)
 	return con	
 except Exception as detail: 
	print " Createdefcon Sucks"
	print detail



def createCursor(con):
 try:
	work_cur = con.cursor()
	return work_cur
 except Exception as detail: 
	print "create cursor Sucks"
	print detail


def insertStuff(): 
 try: 
	
	userid = random.randint(1, 10000)
	username = "Corleone"
	password = "legitimate"
	email = "godfather@sicily"
	
	simple_insert = """ INSERT into user  (user_id,  user_name, user_password, user_email )
			values (%s,"%s", "%s", "%s" ) ;""" %(userid, username, password, email)
	con = createDefCon()
        insert_cur = createCursor(con)
	insert_cur.execute(simple_insert)
	con.close()


 except Exception as detail: 
	print "insert stuff Sucks"
	print detail



def test(): 
 try:
	simple_select = "select user_id from user;" 
	con = createDefCon()
	select_cur = createCursor(con)
	select_cur.execute(simple_select)
	numrows = int(select_cur.rowcount)
	fields = select_cur.description
	numcols = len(fields)
        
	results = select_cur.fetchall()
 
	for i in range(0, numrows):
		for j in range(0, numcols):
			print "Field val : %s" %results[i][j]
	con.close()
	
 except Exception as detail: 
	print " Test Sucks"
	print detail

def printHtml():
	print "Content-Type: text/plain"
	print	

if __name__ == '__main__':
	cgitb.enable() 
	printHtml() 
	test() 
	insertStuff()
