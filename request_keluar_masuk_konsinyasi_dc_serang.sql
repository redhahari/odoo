select b.*
from
(SELECT 
      a.lokasi,
      a.usage,
      a.lokasi_tipe,
      a.dc,
      a.customer,
      'Masuk' as flag,
      a.nama_dagang,
      a.kode_item_lama,
      a.kode_item_baru,
      a.last_update,
      sum(a.quantity) quantity,
      sum(a.list_price) as list_price,
      sum(a.nominal_bruto) as nominal_bruto,
      a.state
FROM       
      (SELECT 
            sm.state,
            sl1.complete_name lokasi,
            sl1.usage,
            sl1.name as lokasi_tipe,
            rp1.name as dc,
            rp2.name as customer,
            pt.name nama_dagang,
            pt.old_koitem kode_item_lama,
            pt.list_price,
            sm.product_id kode_item_baru,
            sm.product_qty quantity,
            round(pt.list_price*sm.product_qty,2) as nominal_bruto,
            cast(sm.write_date as date) as last_update
      FROM stock_move sm
      left join product_template pt on sm.product_id = pt.id 
      left join stock_location sl1 on sm.location_id = sl1.id
      left join res_partner rp1 on rp1.id = sl1.dc_id
      left join res_partner rp2 on rp2.id = sl1.partner_id
      where sl1.usage='internal' and split_part(sl1.complete_name,' ',4) ilike 'C%' and split_part(rp1.name,' ',2) ilike 'serang' and (sm.state='done' or sm.state='available')
      ) a
GROUP BY
      a.state,
      a.lokasi,
      a.usage,
      a.lokasi_tipe,
      a.dc,
      a.customer,
      a.nama_dagang,
      a.kode_item_lama,
      a.kode_item_baru,
      a.last_update

UNION ALL 

SELECT 
      a.lokasi,
      a.usage,
      a.lokasi_tipe,
      a.dc,
      a.customer,
      'Keluar' as flag,
      a.nama_dagang,
      a.kode_item_lama,
      a.kode_item_baru,
      a.last_update,
      sum(a.quantity) quantity,
      sum(a.list_price) as list_price,
      sum(a.nominal_bruto) as nominal_bruto,
      a.state
FROM       
      (SELECT 
            sm.state,
            sl2.complete_name lokasi,
            sl2.usage,
            sl2.name as lokasi_tipe,
            rp1.name as dc,
            rp2.name as customer,
            pt.name nama_dagang,
            pt.old_koitem kode_item_lama,
            pt.list_price,
            sm.product_id kode_item_baru,
            sm.product_qty quantity,
            round(pt.list_price*sm.product_qty,2) as nominal_bruto,
            cast(sm.write_date as date) as last_update
      FROM stock_move sm
      left join product_template pt on sm.product_id = pt.id 
      left join stock_location sl2 on sm.location_dest_id = sl2.id
      left join res_partner rp1 on rp1.id = sl2.dc_id
      left join res_partner rp2 on rp2.id = sl2.partner_id
      where sl2.usage='internal' and split_part(sl2.complete_name,' ',4) ilike 'C%' and split_part(rp1.name,' ',2) ilike 'serang' and (sm.state='done' or sm.state='available')
      ) a
GROUP BY
      a.state,
      a.lokasi,
      a.usage,
      a.lokasi_tipe,
      a.dc,
      a.customer,
      a.nama_dagang,
      a.kode_item_lama,
      a.kode_item_baru,
      a.last_update) b
ORDER BY b.last_update,b.kode_item_baru
