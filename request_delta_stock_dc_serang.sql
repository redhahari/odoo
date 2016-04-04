-- from tanggal 28 sampai dengan 31 maret 2016

-- data stock DARI DC SERANG STOCK

select a.nama_dagang,a.kode_item_lama,a.kode_item_baru,a.lokasi_sumber,a.lokasi_tujuan,a.last_update,a.state,
       sum(a.quantity) as quantity
from
	(select pt.name nama_dagang,
	       pt.old_koitem kode_item_lama,
	       product_id kode_item_baru,
	       product_qty quantity,
	       sl1.complete_name lokasi_sumber,
	       -- sm.location_dest_id lokasi_tujuan,
	       sl2.complete_name lokasi_tujuan,
	       -- sm.location_id,
	       cast(sm.write_date as date) as last_update,
	       sm.state from stock_move sm 
	left join product_template pt on sm.product_id = pt.id 
	left join stock_location sl1 on sl1.id=sm.location_id 
	left join stock_location sl2 on sl2.id=sm.location_dest_id  
	where (sm.state='done' or sm.state='available')  -- Mengambil Stock Move dengan State Done dan Available (Sudah Di Booking Customer)
	and sl1.complete_name ilike '%serang%' -- Untuk Catch Physical Locations / DC Serang / Stock
	and sl1.complete_name ilike '%stock%' -- Untuk Catch Physical Locations / DC Serang / Stock
	and cast(sm.write_date as date) between '2016-03-28' and '2016-03-31') a
 GROUP BY kode_item_baru,kode_item_lama,nama_dagang,lokasi_sumber,lokasi_tujuan,last_update,state
 ORDER BY last_update,kode_item_baru,state

-- data stock KE DC SERANG STOCK

select a.nama_dagang,a.kode_item_lama,a.kode_item_baru,a.lokasi_tujuan,a.last_update,a.state,
       sum(a.quantity) as quantity
from
	(select pt.name nama_dagang,
	       pt.old_koitem kode_item_lama,
	       product_id kode_item_baru,
	       product_qty quantity,
	       sl1.complete_name lokasi_sumber,
	       -- sm.location_dest_id lokasi_tujuan,
	       sl2.complete_name lokasi_tujuan,
	       -- sm.location_id,
	       cast(sm.write_date as date) as last_update,
	       sm.state from stock_move sm 
	left join product_template pt on sm.product_id = pt.id 
	left join stock_location sl1 on sl1.id=sm.location_id 
	left join stock_location sl2 on sl2.id=sm.location_dest_id  
	where (sm.state='done')  -- Mengambil Stock Move dengan State Done dan Available (Sudah Di Booking Customer)
	and sl2.complete_name ilike '%serang%' -- Untuk Catch Physical Locations / DC Serang / Stock
	and sl2.complete_name ilike '%stock%' -- Untuk Catch Physical Locations / DC Serang / Stock
	and cast(sm.write_date as date) between '2016-03-28' and '2016-03-31') a
 GROUP BY kode_item_baru,kode_item_lama,nama_dagang,lokasi_tujuan,last_update,state
 ORDER BY last_update,kode_item_baru,state
