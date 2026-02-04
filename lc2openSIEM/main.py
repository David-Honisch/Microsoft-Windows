from alerts.alert_generator import AlertGenerator
from collectors.syslog_collector import SyslogCollector
from collectors.windows_event_collector import WindowsEventCollector
from config import Config
from processors.alert_processor import AlertProcessor
from processors.log_processor import LogProcessor
from storage.database import DatabaseStorage
from utils.logger import setup_logger

def main():
    product_title = "LC2OpenSIEM"
    print(f"{product_title} (c) 2026 by David Honisch")
    config = Config()
    logger = setup_logger(product_title)
    collectors = {
    'syslog_collector': SyslogCollector(),
    'windows_event_collector': WindowsEventCollector()
    }
    processors = {
    'log_processor': LogProcessor(),
    'alert_processor': AlertProcessor()
    }
    storage = {
    'database': DatabaseStorage()
    }
    alerts = {
    'alert_generator': AlertGenerator()
    }
    for collector_name in config.COLLECTORS:
        collector = collectors[collector_name]
    collector.start()
    for processor_name in config.PROCESSORS:
        processor = processors[processor_name]
    processor.process()
    for storage_name in config.STORAGE:
        storage = storage[storage_name]
    storage.store()
    for alert_name in config.ALERTS:
        alert = alerts[alert_name]
    alert.generate()

if __name__ == '__main__':
    main()