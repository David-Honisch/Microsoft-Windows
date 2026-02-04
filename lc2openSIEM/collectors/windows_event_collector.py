
import win32evtlogutil
import win32evtlog
import logging

from processors.log_processor import LogProcessor
class WindowsEventCollector:
    def __init__(self, log_type='Application'):
        self.log_type = log_type
        self.logger = logging.getLogger('WindowsEventCollector')
    
    def start(self):
        self.logger.info(f'Starting Windows Event collector for {self.log_type}')
        h = win32evtlog.OpenEventLog(None, self.log_type)
        flags = win32evtlog.EVENTLOG_BACKWARDS_READ | win32evtlog.EVENTLOG_SEQUENTIAL_READ
        while True:
            events = win32evtlog.ReadEventLog(h, flags, 0)
            for event in events:
                self.process(event)
    
    def process(self, event):
    # Process Windows event data
        log_entry = f'Event ID: {event.EventID}, Source: {event.SourceName}, Data: {event.StringInserts}'
        self.logger.debug(f'Received Windows event: {log_entry}')
        # Pass to processor
        processor = LogProcessor()
        processor.process(log_entry)