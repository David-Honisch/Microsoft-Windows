### 4. Processors (`processors/`)
#### Log Processor (`log_processor.py`)
import logging

from storage.database import DatabaseStorage
class LogProcessor:
    def __init__(self):
        self.logger = logging.getLogger('LogProcessor')
    
    def process(self, log_entry):
        # Process log entry
        self.logger.debug(f'Processing log entry: {log_entry}')
        # Pass to storage
        storage = DatabaseStorage()
        storage.store(log_entry)
