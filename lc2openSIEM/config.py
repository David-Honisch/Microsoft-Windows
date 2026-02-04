import os
class Config:
    LOG_LEVEL = 'INFO'
    DATABASE_URI = 'sqlite:///siem.db'
    COLLECTORS = [
    'syslog_collector',
    'windows_event_collector'
    ]
    PROCESSORS = [
    'log_processor',
    'alert_processor'
    ]
    STORAGE = 'database'
    ALERTS = 'alert_generator'
