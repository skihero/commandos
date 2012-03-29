#!/usr/bin/python

'''
 Writes the file read from a POST method to
 a specified directory

 Use it with
 <form enctype="multipart/form-data" action="../cgi-bin/save_file.py" method="post">

''' 


import cgi
import cgitb; cgitb.enable();
import os

UPLOAD_DIR="/tmp"

def write_html(name):
        print "Content-type: text/html"
        print ""
        print "<html><body>"
        print "name "
        print name
        print "</body></html>"

def save_file(name,upload_dir):
        if not name.file:
                write_html("Not a proper file")
        #TODO: improve error checking
        fout = file(os.path.join(upload_dir, name.filename), 'wb')
        while 1:
                chunk = name.file.read(100000)
                if not chunk: break
                fout.write(chunk)
        fout.close()
        write_html("File written")

def read_form():
        form = cgi.FieldStorage()
        name = "No file found "

        if form.has_key("file") and form["file"].value !="":
                name = form["file"]
        return name


# Do the work
read_name = read_form()
save_file(read_name,UPLOAD_DIR)

