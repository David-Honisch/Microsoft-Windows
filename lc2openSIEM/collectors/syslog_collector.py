import socket
import logging
class SyslogCollector:
    def __init__(self, host='0.0.0.0', port=514):
        self.host = host
        self.port = port
        self.logger = logging.getLogger('SyslogCollector')
    def start(self):
        self.logger.info(f'Starting Syslog collector on {self.host}:{self.port}')
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
            s.bind((self.host, self.port))
        while True:
            data, addr = s.recvfrom(1024)
            self.process(data)
    
    def process(self, data):
        # Process syslog data
        log_entry = data.decode('utf-8')
        self.logger.debug(f'Received syslog: {log_entry}')
        # Pass to processor
        processor = LogProcessor()
        processor.process(log_entry)
