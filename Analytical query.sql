# Create transaction query
1. Mencari mobil keluaran 2015 ke atas (1% bobot)
SELECT * 
FROM car_product
WHERE YEAR >= 2015;

2. Menambahkan satu data bid produk baru (1% bobot)

3. Melihat semua mobil yg dijual 1 akun dari yg paling baru
SELECT *
FROM car_product 
order date_post desc

4. Mencari mobil bekas yang termurah berdasarkan keyword
SELECT *
FROM car_product
WHERE LOWER(model) LIKE('%ayla%')