from enigma import *
from Screens.Screen import Screen
from Plugins.Plugin import PluginDescriptor
import os

class ShellStarter(Screen):
	skin = """
		<screen position="0,0" size="720,576" title="TuxTXT" >
                </screen>"""

        def __init__(self, session, args = None):
		print "__init"
        	self.skin = ShellStarter.skin
		Screen.__init__(self, session)
		#self.container=eConsoleAppContainer()
		#self.container.appClosed.get().append(self.finished)
		self.runapp()
		
	def runapp(self):
		print "runappt"
		service = self.session.nav.getCurrentService()
		if service is not None:
			self.info = service.info()
		else:
			self.info = None

		#eDBoxLCD.getInstance().lock()
		#eRCInput.getInstance().lock()
		#fbClass.getInstance().lock()
		#if self.container.execute("/usr/bin/tuxtxt "+self.getValue(iServiceInformation.sTXTPID)):
		s="/usr/bin/tuxtxt "
		s+=self.getValue(iServiceInformation.sTXTPID)
		s+=" &"
		print s
		try:
			os.popen(s)
		except OSError, e: 
			print "OSError: ", e
			#print "OSError"
			#Why cant i use openWithCallback?
			#from Screens.MessageBox import MessageBox
			#def msgClosed(ret):
			#	return
			#self.session.openWithCallback(msgClosed, MessageBox, _("Swap needed"), MessageBox.TYPE_INFO)

			self.finished(-1)
		self.finished(-1)

	def finished(self,retval):
		print "finished"
		#fbClass.getInstance().unlock()
		#eRCInput.getInstance().unlock()
		#eDBoxLCD.getInstance().unlock()
		self.close()

	def getValue(self, what):
		print "getValue"
		if self.info is None:
			return ""
		
		v = "%d" % (self.info.getInfo(what))

		return v


def main(session, **kwargs):
	print "main"
	session.open(ShellStarter)

def Plugins(**kwargs):
	print "Plugins"
	return PluginDescriptor(name="TuxTXT", description="Videotext", where = PluginDescriptor.WHERE_TELETEXT, fnc=main)
