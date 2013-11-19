""" Used in conjuction with a keyboard shortcut to 
capture a screenshot and upload to imgur, returns 
the public imgur link of the screenshot 

Useful in sharing a screenshot link without having to 
manually take a screenshot and upload thru the browser """ 

import gtk.gdk
import pycurl

w = gtk.gdk.get_default_root_window()
sz = w.get_size()
print "The size of the window is %d x %d" % sz
pb = gtk.gdk.Pixbuf(gtk.gdk.COLORSPACE_RGB,False,8,sz[0],sz[1])
pb = pb.get_from_drawable(w,w.get_colormap(),0,0,0,0,sz[0],sz[1])
if (pb != None):
    pb.save("screenshot.png","png")
    print "Screenshot saved to screenshot.png."
    imgfile = "screenshot.png"
    
else:
    print "Unable to get the screenshot."


cookie_file_name = "/tmp/imagurcookie"
		
		if ( self.username!="" and self.password!=""):
			l=pycurl.Curl()
			loginData = [ ("username",self.username),("password", self.password), ("submit", "Continue") ]
			l.setopt(l.URL, "http://imgur.com/signin")
			l.setopt(l.HTTPPOST, loginData)
			#l.setopt(l.USERAGENT,"User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4) Gecko/20091028 Ubuntu/9.10 (karmic) Firefox/3.5.1")
			l.setopt(l.FOLLOWLOCATION,1)
			l.setopt(l.COOKIEFILE,cookie_file_name)
			l.setopt(l.COOKIEJAR,cookie_file_name)
			l.setopt(l.HEADER,1)
			loginDataReturnedBuffer = StringIO.StringIO()
			l.setopt( l.WRITEFUNCTION, loginDataReturnedBuffer.write )
			
			if l.perform():
				self.broadcasts.append("Login failed. Check connection.")
				l.close()
				return

			loginDataReturned = loginDataReturnedBuffer.getvalue()
			l.close()
			#print loginDataReturned
			
			if loginDataReturned.find("<title>Sign In - Imgur</title>")!=-1:
				self.broadcasts.append("Login to Imagur failed. Username/password mismatch")
				return

