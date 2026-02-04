import logging
class AlertGenerator:
    def __init__(self):
        self.logger = logging.getLogger('AlertGenerator')
    def generate(self, log_entry):
        # Generate alert from log entry
        self.logger.debug(f'Generating alert from log entry: {log_entry}')
        if 'ERROR' in log_entry:
            return f'Alert: High severity error detected in log entry: {log_entry}'
        return None
