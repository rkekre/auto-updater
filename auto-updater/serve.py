#!/usr/bin/python

from SocketServer import TCPServer, StreamRequestHandler
import socket
import logging
import datetime
import threading
import time
import subprocess


class ThreadingExample(object):
    """ Threading example class
    The run() method will be started and it will run in the background
    until the application exits.
    """

    def __init__(self, interval=30):
        """ Constructor
        :type interval: int
        :param interval: Check interval, in seconds
        """
        self.interval = interval

        thread = threading.Thread(target=self.run, args=())
        thread.daemon = True                            # Daemonize thread
        thread.start()                                  # Start the execution

    def run(self):
        """ Method that runs forever """
        while True:
            subprocess.call("/tmp/dummy_service/checkForUpdates.sh", shell=True)
            time.sleep(self.interval)


class Handler(StreamRequestHandler):
    def handle(self):
        self.data = self.rfile.readline().strip()
        logging.info("From <%s>: %s" % (self.client_address, self.data))
        self.wfile.write("Updated message: " + self.data.upper() + "\nCurrent Time: " + datetime.datetime.now().strftime("%H:%M:%S")  + "\nCurrent Date: " + datetime.datetime.now().strftime("%d:%m:%Y") + "\n")

class Server(TCPServer):
    
    # The constant would be better initialized by a systemd module
    SYSTEMD_FIRST_SOCKET_FD = 3

    def __init__(self, server_address, handler_cls):
        # Invoke base but omit bind/listen steps (performed by systemd activation!)
        TCPServer.__init__(
            self, server_address, handler_cls, bind_and_activate=False)
        # Override socket
        self.socket = socket.fromfd(
            self.SYSTEMD_FIRST_SOCKET_FD, self.address_family, self.socket_type)

if __name__ == "__main__": 
    background_update_process = ThreadingExample()
    logging.basicConfig(level=logging.INFO)
    HOST, PORT = "localhost", 9999 # not really needed here
    server = Server((HOST, PORT), Handler)
    server.serve_forever()
