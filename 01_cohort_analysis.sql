-- Purpose: hourly sales cartons information

WITH vbak AS (
  SELECT
    vbeln,
    erdat,
    stceg_l,
    auart,
    lifsk,
    erzet AS vbak_erzet,
    LEFT(CAST(erzet AS STRING), 2) AS hour
  FROM `vbak`
  WHERE erdat >= '2020-01-01'
    AND auart IN ('ZCRD','ZFRE')
),

vbap AS (
  SELECT DISTINCT
    vbeln,
    matnr,
    posnr,
    kwmeng,
    werks
  FROM `vbap`
  WHERE erdat >= '2020-01-01'
    AND matnr LIKE '%.%'
),

sales_data AS (
  SELECT 
    vbak.vbeln,
    erdat,
    stceg_l,
    auart,
    lifsk,
    vbak_erzet,
    hour,
    CASE WHEN CAST(hour AS INTEGER) >= 12 THEN 'Afternoon' ELSE 'Morning' END AS period,
    matnr,
    posnr,
    kwmeng,
    werks
  FROM vbak
  INNER JOIN vbap
    ON vbak.vbeln = vbap.vbeln
),

min_max_zcrd AS (
  SELECT
    MIN(vbeln) AS min_zcrd,
    MAX(vbeln) AS max_zcrd
  FROM sales_data
  WHERE auart = 'ZCRD'
),

min_max_zfre AS (
  SELECT
    MIN(vbeln) AS min_zfre,
    MAX(vbeln) AS max_zfre
  FROM sales_data
  WHERE auart = 'ZFRE'
),

vbpa AS (
  SELECT DISTINCT
    vbeln,
    parvw,
    lifnr
  FROM `vbpa`
  WHERE parvw = 'SP'
    AND (
      vbeln BETWEEN (SELECT min_zcrd FROM min_max_zcrd) AND (SELECT max_zcrd FROM min_max_zcrd) OR
      vbeln BETWEEN (SELECT min_zfre FROM min_max_zfre) AND (SELECT max_zfre FROM min_max_zfre)
    )
),

final AS (
  SELECT
    sales_data.*,
    parvw,
    lifnr,
    CONCAT(sales_data.vbeln, posnr) AS distinct_key,
    "real data" AS data_type
  FROM sales_data
  INNER JOIN vbpa
    ON sales_data.vbeln = vbpa.vbeln
),

forecast_data AS (
  SELECT
    CAST(NULL AS STRING) AS vbeln,
    PARSE_DATE('%d-%m-%Y', `date`) AS erdat,
    country AS stceg_l,
    CAST(NULL AS STRING) AS auart,
    CAST(NULL AS STRING) AS lifsk,
    CAST(NULL AS TIME) AS vbak_erzet,
    CAST(NULL AS STRING) AS hour,
    CAST(NULL AS STRING) AS period,
    CAST(NULL AS STRING) AS matnr,
    CAST(NULL AS STRING) AS posnr,
    CAST(country_day_intake AS NUMERIC) AS kwmeng,
    plant AS werks,
    CAST(NULL AS STRING) AS parvw,
    CAST(NULL AS STRING) AS lifnr,
    CAST(NULL AS STRING) AS distinct_key,
    "forecast data" AS data_type
  FROM `excel_sheet.forecast_1week_salescartons`
)

SELECT final.* FROM final

UNION ALL 

SELECT forecast_data.* FROM forecast_data
