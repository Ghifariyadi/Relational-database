# Create analytical query

1. Ranking popularitas model mobil berdasarkan jumlah bid (2% bobot)
SELECT cp.model, COUNT(DISTINCT product_id), COUNT(DISTINCT bid_id)
FROM car_product as cp
LEFT JOIN bid_details as b
ON cp.product_id = b.product_id
GROUP BY 1
ORDER BY 3 DESC

2. Membandingkan harga mobil berdasarkan harga rata-rata per kota
SELECT c.nama_kota, cp.brand, cp.model, cp.year, cp.price, 
AVG(PRICE) OVER(PARTITION by c.nama_kota) as avg_per_city
FROM city as c
LEFT JOIN car_product as cp
ON c.kota_id = cp.kota_id;

3. Dari penawaran suatu model mobil, cari perbandingan 
tanggal user melakukan bid dengan bid selanjutnya beserta 
harga tawar yang diberikan

SELECT C.BRAND, B.CUSTOMER_ID, B.DATE, B.PRICE
FROM BID_DETAILS AS B
LEFT JOIN CAR_PRODUCT AS C
ON B.PRODUCT_ID = C.PRODUCT_ID;

4. Membandingkan persentase perbedaan rata-rata harga mobil 
berdasarkan modelnya dan rata-rata harga bid yang ditawarkan oleh customer 
pada 6 bulan terakhir

WITH CTE AS (
	SELECT DISTINCT CP.MODEL, ROUND(AVG(CP.PRICE) OVER(PARTITION BY CP.MODEL)) AS AVG_PRICE, 
	ROUND(AVG(B.PRICE) OVER(PARTITION BY CP.MODEL)) AS avg_bid_6month
	FROM CAR_PRODUCT AS CP
	LEFT JOIN BID_DETAILS AS B
	ON CP.PRODUCT_ID = B.PRODUCT_ID
	WHERE B.DATE > '2022-11-01')

SELECT *, avg_price - avg_bid_6month as difference,
(avg_price - avg_bid_6month)/avg_price as difference_percent
FROM CTE

5. Membuat window function rata-rata harga bid sebuah merk 
dan model mobil selama 6 bulan terakhir
WITH M_6 AS (
SELECT DISTINCT BRAND, MODEL, 
ROUND(AVG(CP.PRICE) OVER(PARTITION BY CP.MODEL)) AS m_min_6
FROM CAR_PRODUCT AS CP
	LEFT JOIN BID_DETAILS AS B
	ON CP.PRODUCT_ID = B.PRODUCT_ID
WHERE B.DATE BETWEEN '2022-11-01' AND '2022-11-30'
),

M_5 AS (
SELECT DISTINCT BRAND, MODEL, 
ROUND(AVG(CP.PRICE) OVER(PARTITION BY CP.MODEL)) AS m_min_5
FROM CAR_PRODUCT AS CP
	LEFT JOIN BID_DETAILS AS B
	ON CP.PRODUCT_ID = B.PRODUCT_ID
WHERE B.DATE BETWEEN '2022-12-01' AND '2022-12-31'
),

M_4 AS (
SELECT DISTINCT BRAND, MODEL, 
ROUND(AVG(CP.PRICE) OVER(PARTITION BY CP.MODEL)) AS m_min_4
FROM CAR_PRODUCT AS CP
	LEFT JOIN BID_DETAILS AS B
	ON CP.PRODUCT_ID = B.PRODUCT_ID
WHERE B.DATE BETWEEN '2023-01-01' AND '2023-1-31'
),

M_3 AS (
SELECT DISTINCT BRAND, MODEL, 
ROUND(AVG(CP.PRICE) OVER(PARTITION BY CP.MODEL)) AS m_min_3
FROM CAR_PRODUCT AS CP
	LEFT JOIN BID_DETAILS AS B
	ON CP.PRODUCT_ID = B.PRODUCT_ID
WHERE B.DATE BETWEEN '2023-2-01' AND '2023-2-28'
),


M_2 AS (
SELECT DISTINCT BRAND, MODEL, 
ROUND(AVG(CP.PRICE) OVER(PARTITION BY CP.MODEL)) AS m_min_2
FROM CAR_PRODUCT AS CP
	LEFT JOIN BID_DETAILS AS B
	ON CP.PRODUCT_ID = B.PRODUCT_ID
WHERE B.DATE BETWEEN '2023-3-01' AND '2023-3-31'
),

M_1 AS (
SELECT DISTINCT BRAND, MODEL, 
ROUND(AVG(CP.PRICE) OVER(PARTITION BY CP.MODEL)) AS m_min_1
FROM CAR_PRODUCT AS CP
	LEFT JOIN BID_DETAILS AS B
	ON CP.PRODUCT_ID = B.PRODUCT_ID
WHERE B.DATE BETWEEN '2023-4-01' AND '2023-4-30'
)

SELECT BRAND, MODEL, MIN(m_min_6), MIN(m_min_5), MIN(m_min_4),
MIN(m_min_3), MIN(m_min_2), MIN(m_min_1)
FROM
	(SELECT M_6.BRAND, M_6.MODEL, M_6.m_min_6, M_5.m_min_5, M_4.m_min_4,
	M_3.m_min_3, M_2.m_min_2, M_1.m_min_1
	FROM M_6 
	FULL OUTER JOIN M_5 ON M_6.BRAND = M_5.BRAND
	FULL OUTER JOIN M_4 ON M_6.BRAND = M_4.BRAND
	FULL OUTER JOIN M_3 ON M_6.BRAND = M_3.BRAND
	FULL OUTER JOIN M_2 ON M_6.BRAND = M_2.BRAND
	FULL OUTER JOIN M_1 ON M_6.BRAND = M_1.BRAND) AS FOO
GROUP BY 1,2
