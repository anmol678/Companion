
from fileinput import filename
import glob
import os
import re
import pandas as pd
import numpy as np


def format_files(path):
    files = glob.glob(path + '/*.csv')

    for filename in files:

        newFilename = filename.replace('HKQuantityTypeIdentifier', '').replace('HKCategoryTypeIdentifier', '').replace('_SimpleHealthExportCSV', '')
        os.rename(filename, newFilename)

        df = pd.read_csv(newFilename)

        for col in ['startDate', 'endDate']:
            df[col] = pd.to_datetime(df[col])

        if 'value' in df:
            df['value'] = pd.to_numeric(df['value'], errors='coerce')
            df['value'] = df['value'].fillna(1.0)

        df['type'] = df['type'].str.replace('HKQuantityTypeIdentifier', '')
        df['type'] = df['type'].str.replace('HKCategoryTypeIdentifier', '')

        # df = df.drop('device', axis=1)

        # df.drop(df.filter(regex='Unname'), axis=1, inplace=True)

        df.to_csv(newFilename)


def parse_files(path):

    aggregateFeatures = ['HeartRate', 'HeartRateVariabilitySDNN', 'OxygenSaturation', 'RespiratoryRate', 'RestingHeartRate', 'WalkingHeartRateAverage', 'WalkingSpeed']

    files = glob.glob(path + '/*.csv')

    data = pd.DataFrame()

    for filename in files:

        # file = glob.glob(path + '/' + filename + '*.csv')

        df = pd.read_csv(filename)
        feature = re.split('/+|_', filename)[2]

        for col in ['startDate', 'endDate']:
            df[col] = pd.to_datetime(df[col])
            df[col] = df[col].dt.tz_convert('America/Los_Angeles')

        pivot_df = df.pivot_table(index='endDate', values='value')
        
        if (feature in aggregateFeatures):
            df = pivot_df.resample('D').agg(np.mean)
        else:
            df = pivot_df.resample('D').agg(sum)

        df.rename({'value': feature}, axis=1, inplace=True)

        # print(df)

        data = pd.concat([data, df], axis=1)

    data.to_csv('data.csv')


def parse_sleep():
    file = glob.glob('./SleepAnalysis*.csv')
    df = pd.read_csv(file[0], skiprows=1)

    for col in ['startDate', 'endDate']:
        df[col] = pd.to_datetime(df[col])
        df[col] = df[col].dt.tz_convert('America/Los_Angeles')

    df = df[df['productType'].str.contains('iPhone')]
    df = df[['startDate', 'endDate', 'value']]

    # df.drop(['type', 'HKTimeZone', 'sourceName', 'source'])

    df['SleepDuration'] = df['endDate'] - df['startDate']

    pivot_df = df.pivot_table(index='endDate', values='SleepDuration')
    df = pivot_df.resample('D').agg(sum)

    df['SleepDuration'] = df['SleepDuration'] / pd.Timedelta('1 hour')

    data = pd.read_csv('./data.csv')

    data = data.drop('SleepAnalysis', axis=1).drop(labels=0, axis=0)
    data['endDate'] = pd.to_datetime(data['endDate'])
    data['endDate'] = data['endDate'].dt.tz_convert('America/Los_Angeles')

    df = df.reset_index(drop=True)
    df.index = np.arange(1,len(df)+1)
    # print(df)

    data = pd.concat([data, df], axis=1)
    # print(data)

    data.to_csv('data.csv')


def main():
    # format_files('./Data')
    # parse_files('./Data')
    # parse_sleep()


if __name__ == "__main__":
    main()