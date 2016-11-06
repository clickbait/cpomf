import os

BASE_DIR = os.path.dirname(os.path.realpath(__file__))

DATABASES = {
    'default': {
        'migrations_dir': os.path.join(BASE_DIR, "migrations"),
        'engine': 'postgres',
        'dsn': os.environ['POMF_DATABASE_URL'],
    }
}

LOG_FILE = os.path.join(BASE_DIR, "migration.log")
