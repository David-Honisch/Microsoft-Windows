import logging
class AlertProcessor:
    def __init__(self):
        self.logger = logging.getLogger('AlertProcessor')
    
    def process(self, log_entry):
        # Process log entry for alerts
        self.logger.debug(f'Processing log entry for alerts: {log_entry}')
        # Generate alert
        alert_generator = AlertGenerator()
        alert = alert_generator.generate(log_entry)
        # Pass to storage
        storage = DatabaseStorage()
        storage.store(alert)
