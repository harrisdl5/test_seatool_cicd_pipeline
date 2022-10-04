#!/usr/bin/env python3

import botocore
import boto3
import datetime
import os


today = datetime.datetime.now()
timestamp = today.strftime("%d-%m-%Y-%H-%M-%S-%f")

dbname = os.getenv('DB_IDENTIFIER')
snapname = "".join((os.getenv('SNAPSHOT_NAME'),timestamp))

client = boto3.client('rds')

response = client.create_db_snapshot(
    DBInstanceIdentifier= dbname,
    DBSnapshotIdentifier= snapname
)

snapshot_id = response['DBSnapshot']['DBSnapshotIdentifier']
waiter = client.get_waiter('db_snapshot_completed')

try:
    print ('Snapshot in progress...\n')
    waiter.wait(DBSnapshotIdentifier=snapshot_id)
except botocore.exceptions.WaitError as error:
    print (error)
else:
    current = client.describe_db_snapshots(DBSnapshotIdentifier = snapname)
    for status in current['DBSnapshots']:
        print  ('DB:',status['DBInstanceIdentifier'],'\nDB Snapshot Name',status['DBSnapshotIdentifier'],'\nSnapshot Status:',status['Status'])