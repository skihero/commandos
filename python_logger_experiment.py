t the usage of the logger module 
# FIX:  not working


import sys
import os
import logging
from optparse import OptionParser, Option

__version__ = 0.1

class OptionParser_extended(OptionParser):
    def print_help(self):
        OptionParser.print_help(self)
        print
        print "Some examples:"

class progOption (Option):
    """Allow to specify comma delimited list of plugins"""
    ACTIONS = Option.ACTIONS + ("extend",)
    STORE_ACTIONS = Option.STORE_ACTIONS + ("extend",)
    TYPED_ACTIONS = Option.TYPED_ACTIONS + ("extend",)
    # Take action
    def take_action(self, action, dest, opt, value, values, parser):
        if action == "extend":
            try: lvalue = value.split(",")
            except: pass
            else: values.ensure_value(dest, []).extend(lvalue)
        else:
            Option.take_action(self, action, dest, opt, value, values, parser)



__cmdParser__ = OptionParser_extended(option_class=progOption)
__cmdParser__.add_option("-v", "--verbose", action="count", \
                     dest="verbosity", \
                     help="increase verbosity")

(__cmdLineOpts__, __cmdLineArgs__)=__cmdParser__.parse_args()


def mylog():
   # Set destinationss 
   logdir = os.path.join("/tmp", "prog_logs")

   try:
           if not os.path.isdir(logdir):
                   os.mkdir(logdir, 0755)
   except: 
           print "Path error:", sys.exc_info()

   # initialize logging
   proglog = logging.getLogger('prog')
   proglog.setLevel(logging.DEBUG)

   logging.VERBOSE  = logging.INFO - 1
   logging.VERBOSE2 = logging.INFO - 2
   logging.VERBOSE3 = logging.INFO - 3
   logging.addLevelName(logging.VERBOSE, "verbose")
   logging.addLevelName(logging.VERBOSE2,"verbose2")
   logging.addLevelName(logging.VERBOSE3,"verbose3")

   print "logfile creation"
   # log to a file
   flog = logging.FileHandler(logdir + "/prog.log")
   flog.setFormatter(logging.Formatter('%(asctime)s %(levelname)s: %(message)s'))
   flog.setLevel(logging.VERBOSE3)
   proglog.addHandler(flog)


   print "after log file" 
   # define a Handler which writes INFO messages or higher to the sys.stderr
   console = logging.StreamHandler(sys.stderr)
   if __cmdLineOpts__.verbosity > 0:
       console.setLevel(20 - __cmdLineOpts__.verbosity)
       __cmdLineOpts__.progressbar = False
   else:
       console.setLevel(logging.INFO)
   console.setFormatter(logging.Formatter('%(message)s'))
   proglog.addHandler(console)

   print "Trying to print" 
   proglog.info ( _("prog_name (version %s)") % __version__)
   print " After info print" 
   proglog.info ( _("prog_name (version %s)") % __version__)
   print

   proglog.log(logging.VERBOSE, "Something verbose " )
   proglog.log(logging.DEBUG, "Something debug returned" )

   # Close all log files and perform any cleanup
   logging.shutdown()


if __name__ == '__main__':
    try:
        mylog()

    except: 
        print 'Exception: '
        print "Unexpected error:", sys.exc_info()


