import logging

def get_logger(name):
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(name)
    return logger