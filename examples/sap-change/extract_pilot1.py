"""Extract minimal teaching extracts from the CDISC pilot ADaM XPT files.

Source files (retrieved 2026-09-08, provenance.md has hashes):
  adsl.xpt   - https://raw.githubusercontent.com/RConsortium/submissions-pilot1/main/adam/adsl.xpt
  adadas.xpt - https://raw.githubusercontent.com/RConsortium/submissions-pilot1/main/adam/adadas.xpt
  (identical copies in cdisc-org/sdtm-adam-pilot-project under
  updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/analysis/adam/datasets/)

Run: /tmp/xptvenv/bin/python extract_pilot1.py  (needs pyreadstat + pandas)

Scope boundary: visit assignment (AVISITN) is taken as given from ADaM.
The example re-derives Week-24 record *selection* within AVISITN == 24 only.
"""
import pyreadstat
import csv

SRC = '/tmp'

adsl, _ = pyreadstat.read_xport(f'{SRC}/adsl.xpt')
adsl_cols = ['USUBJID', 'ARM', 'ITTFL', 'SAFFL', 'EFFFL', 'COMP24FL', 'DCDECOD']
adsl[adsl_cols].to_csv('data/adsl_extract.csv', index=False,
                      quoting=csv.QUOTE_NONNUMERIC)
print('adsl_extract.csv rows:', len(adsl))

ad, _ = pyreadstat.read_xport(f'{SRC}/adadas.xpt')
cols = ['USUBJID', 'TRTP', 'TRTPN', 'SITEGR1', 'EFFFL', 'ITTFL', 'PARAMCD',
        'AVISITN', 'ADY', 'AVAL', 'BASE', 'CHG', 'ANL01FL', 'DTYPE',
        'AWTARGET', 'AWLO', 'AWHI']
week24 = ad[(ad['PARAMCD'] == 'ACTOT') & (ad['AVISITN'] == 24)].copy()
week24[cols].to_csv('data/adadas_week24_extract.csv', index=False,
                  quoting=csv.QUOTE_NONNUMERIC)
print('adadas_week24_extract.csv rows:', len(week24))
