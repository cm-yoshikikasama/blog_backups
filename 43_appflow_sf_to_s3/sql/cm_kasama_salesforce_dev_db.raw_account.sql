CREATE EXTERNAL TABLE cm_kasama_salesforce_dev_db.raw_account(
  Id STRING,
  IsDeleted BOOLEAN,
  MasterRecordId STRING,
  Name STRING,
  Type STRING,
  ParentId STRING,
  BillingStreet STRING,
  BillingCity STRING,
  BillingState STRING,
  BillingPostalCode STRING,
  BillingCountry STRING,
  BillingLatitude DOUBLE,
  BillingLongitude DOUBLE,
  BillingGeocodeAccuracy STRING,
  BillingAddress STRING,
  ShippingStreet STRING,
  ShippingCity STRING,
  ShippingState STRING,
  ShippingPostalCode STRING,
  ShippingCountry STRING,
  ShippingLatitude DOUBLE,
  ShippingLongitude DOUBLE,
  ShippingGeocodeAccuracy STRING,
  ShippingAddress STRING,
  Phone STRING,
  Fax STRING,
  AccountNumber STRING,
  Website STRING,
  PhotoUrl STRING,
  Sic STRING,
  Industry STRING,
  AnnualRevenue STRING,
  NumberOfEmployees INT,
  Ownership STRING,
  TickerSymbol STRING,
  Description STRING,
  Rating STRING,
  Site STRING,
  OwnerId STRING,
  CreatedDate TIMESTAMP,
  CreatedById STRING,
  LastModifiedDate TIMESTAMP,
  LastModifiedById STRING,
  SystemModstamp TIMESTAMP,
  LastActivityDate TIMESTAMP,
  LastViewedDate TIMESTAMP,
  LastReferencedDate TIMESTAMP,
  Jigsaw STRING,
  JigsawCompanyId STRING,
  CleanStatus STRING,
  AccountSource STRING,
  DunsNumber STRING,
  Tradestyle STRING,
  NaicsCode STRING,
  NaicsDesc STRING,
  YearStarted STRING,
  SicDesc STRING,
  DandbCompanyId STRING,
  OperatingHoursId STRING,
  CustomerPriority__c STRING,
  SLA__c STRING,
  Active__c STRING,
  NumberofLocations__c DOUBLE,
  UpsellOpportunity__c STRING,
  SLASerialNumber__c STRING,
  SLAExpirationDate__c TIMESTAMP
)
PARTITIONED BY (
    year string,
    month string,
    day string
)
STORED AS PARQUET
LOCATION 's3://<your-s3-bucket>/cm-kasama-dev-sf-account-flow/'
TBLPROPERTIES (
    'projection.enabled' = 'true',
    'projection.year.type' = 'date',
    'projection.year.format' = 'yyyy',
    'projection.year.range' = '2024,NOW',
    'projection.month.type' = 'integer',
    'projection.month.range' = '1,12',
    'projection.month.digits' = '2',
    'projection.day.type' = 'integer',
    'projection.day.range' = '1,31',
    'projection.day.digits' = '2',
    'storage.location.template' = 's3://<your-s3-bucket>/cm-kasama-dev-sf-account-flow/${year}/${month}/${day}'
);
