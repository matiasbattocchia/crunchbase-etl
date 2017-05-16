#!/usr/bin/env python

import sys, os, argparse, subprocess

# Crunchbase API key

# Databases
LOCAL       = 'crunchbase'
DEVELOPMENT = ''
PRODUCTION  = ''


def psql(file):
    print('\n' + 'Running ' + file + '\n')
    output = subprocess.call(['psql', db, '-f', '../migrate/' + file])

    if output != 0: sys.exit(1)


parser = argparse.ArgumentParser(description='Create/update Crunchbase data')

parser.add_argument('--download', action='store_true', \
    help='download Crunchbase daily CSV export')

parser.add_argument('environment', default='local', \
    choices=['local', 'development', 'production'], \
    help='target database')

args = parser.parse_args()


if   args.environment == 'local':
    db = LOCAL
elif args.environment == 'development':
    db = DEVELOPMENT
elif args.environment == 'production':
    db = PRODUCTION


base_dir = os.path.dirname(os.path.abspath(__file__))
os.chdir(base_dir)

if not os.path.exists('data'): os.makedirs('data')

os.chdir('data')


if args.download:
    # Download Crunchbase daily CSV export
    print('Downloading Crunchbase CSV export...')
    subprocess.call(['wget', '--output-document=csv_export.tar.gz',
        'https://api.crunchbase.com/v/3/csv_export/csv_export.tar.gz?user_key=%s' % API_KEY])

    # Uncompress files
    print('Uncompressing files...')
    subprocess.call(['tar', '-xzf', 'csv_export.tar.gz'])

    # 1. Round floats to integers so the DB does not complain
    # 2. Replace [ for { and ] for } which are the expected array format
    # 3. Remove empty/white strings
    # 4. Remove [-\s] strings
    print('Preprocessing files...')
    subprocess.call("sed 's/,\([0-9]\{1,\}\)\.[0-9]*,/,\\1,/g;s/\[/{/g;s/\]/}/g;s/,\" *\",/,,/g;s/,[- ]\{1,\},/,,/g' organizations.csv > organizations_transformed.csv", shell=True)


if not os.path.exists('organizations.csv'):
    print('No data files. Maybe you forgot the --download flag?')
    sys.exit(1)


# Create/update Crunchbase data
psql('drop_crunchbase_tables.sql')
psql('create_organizations.sql')
psql('create_funding_rounds.sql')
psql('create_investors.sql')
psql('create_investments.sql')
#psql('create_funds.sql')
psql('create_ipos.sql')
psql('create_acquisitions.sql')
#psql('create_people.sql')

# There is no Salesforce data in local environments
if args.environment != 'local':
    # This script must run after Crunchbase data is available
    psql('create_salesforce_organizations.sql')

#psql('create_deal_sourcing_scores.sql')

# This one should run at the very end
#psql('create_etl_dates.sql')

print('\n' + 'DONE!')

#psql('create_tracxn_companies.sql')
#psql('create_tracxn_categories.sql')
