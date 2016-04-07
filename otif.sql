SELECT 
noso,
date_order,
dc,
customer,
salesname,
order_method,
brand,
coitem,
product_id,
ordered_quantity,
delivered_quantity,
invoiced_quantity,
unit_price,
price_after_discounts,
price_subtotal,
invoice_status,
qty_to_invoice,
qty_returned,
state,
warehouse,
street,
kecamatan,
kelurahan,
channel,
kode_tipe_outlet,
jenis_outlet,
area,
cara_bayar,
kat1,
kat2,
product,
leadtime,
date_invoice,
case when invoiced_quantity is null then 1 else 0
end as kosong,
case when date_invoice is not null then 
                         case when (
                                    date_invoice > (date_order + coalesce(leadtime,1) * interval '1 day') +  

                                                            (
                                                              (select count(tanggal) from dim_hol where tanggal between date_order and date_order + (coalesce(leadtime,1) * interval '1 day')
                                                              ) * interval '1 day'
                                                            ) +
                                                            (
                                                              (select count(*) from dim_time 
                                                                 where 
                                                                 (date between date_order and date_invoice + 
                                                                  (coalesce(leadtime,1) * interval '1 day') 
                                                                  ) 
                                                                  and 
                                                                 day_name like 'Sunday'
                                                              ) * interval '1 day' 
                                                            )

                                    ) and (invoiced_quantity < ordered_quantity) then 0
                              when (date_invoice <= (date_order + coalesce(leadtime,1) * interval '1 day') +  

                                                            (
                                                              (select count(tanggal) from dim_hol where tanggal between date_order and date_order + (coalesce(leadtime,1) * interval '1 day')
                                                              ) * interval '1 day'
                                                            ) +
                                                            (
                                                              (select count(*) from dim_time 
                                                                 where 
                                                                 (date between date_order and date_order + 
                                                                  (coalesce(leadtime,1) * interval '1 day') 
                                                                  ) 
                                                                  and 
                                                                 day_name like 'Sunday'
                                                              ) * interval '1 day' 
                                                            )

                                    ) and (invoiced_quantity < ordered_quantity) then 1 else 0 end
     when date_invoice is null then
     case when current_date <= (rp_co_faktur.tglbon + coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') +  

                                                            (
                                                              (select count(tanggal) from dim_hol where tanggal between rp_co_faktur.tglbon and rp_co_faktur.tglbon + (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day')
                                                              ) * interval '1 day'
                                                            ) +
                                                            (
                                                              (select count(*) from dim_time 
                                                                 where 
                                                                 (date between rp_co_faktur.tglbon and rp_co_faktur.tglbon + 
                                                                  (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') 
                                                                  ) 
                                                                  and 
                                                                 day_name like 'Sunday'
                                                              ) * interval '1 day' 
                                                            ) and (rp_co_faktur.qtydipesan_faktur < rp_co_faktur.qtydipesan_co)
                                then 1
           when current_date > (rp_co_faktur.tglbon + coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') +  

                                                            (
                                                              (select count(tanggal) from dim_hol where tanggal between rp_co_faktur.tglbon and rp_co_faktur.tglbon + (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day')
                                                              ) * interval '1 day'
                                                            ) +
                                                            (
                                                              (select count(*) from dim_time 
                                                                 where 
                                                                 (date between rp_co_faktur.tglbon and rp_co_faktur.tglbon + 
                                                                  (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') 
                                                                  ) 
                                                                  and 
                                                                 day_name like 'Sunday'
                                                              ) * interval '1 day' 
                                                            ) and (rp_co_faktur.qtydipesan_faktur < rp_co_faktur.qtydipesan_co)
                                then 0

          else 0 
    end
    else 0
 end as ontime,
 case when rp_co_faktur.tglserah is not null then 
               
                         case when (rp_co_faktur.tglserah > (rp_co_faktur.tglbon + coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') +  

                                                            (
                                                              (select count(tanggal) from dim_hol where tanggal between rp_co_faktur.tglbon and rp_co_faktur.tglbon + (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day')
                                                              ) * interval '1 day'
                                                            ) +
                                                            (
                                                              (select count(*) from dim_time 
                                                                 where 
                                                                 (date between rp_co_faktur.tglbon and rp_co_faktur.tglbon + 
                                                                  (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') 
                                                                  ) 
                                                                  and 
                                                                 day_name like 'Sunday'
                                                              ) * interval '1 day' 
                                                            )) and (rp_co_faktur.qtydipesan_faktur >= rp_co_faktur.qtydipesan_co) then 0
                              when (rp_co_faktur.tglserah <= (rp_co_faktur.tglbon + coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') +  

                                                            (
                                                              (select count(tanggal) from dim_hol where tanggal between rp_co_faktur.tglbon and rp_co_faktur.tglbon + (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day')
                                                              ) * interval '1 day'
                                                            ) +
                                                            (
                                                              (select count(*) from dim_time 
                                                                 where 
                                                                 (date between rp_co_faktur.tglbon and rp_co_faktur.tglbon + 
                                                                  (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') 
                                                                  ) 
                                                                  and 
                                                                 day_name like 'Sunday'
                                                              ) * interval '1 day' 
                                                            )) and (rp_co_faktur.qtydipesan_faktur >= rp_co_faktur.qtydipesan_co) then 1 else 0 end
          

       when rp_co_faktur.tglserah is null then 

          case when current_date <= (rp_co_faktur.tglbon + coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') +  

                                                            (
                                                              (select count(tanggal) from dim_hol where tanggal between rp_co_faktur.tglbon and rp_co_faktur.tglbon + (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day')
                                                              ) * interval '1 day'
                                                            ) +
                                                            (
                                                              (select count(*) from dim_time 
                                                                 where 
                                                                 (date between rp_co_faktur.tglbon and rp_co_faktur.tglbon + 
                                                                  (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') 
                                                                  ) 
                                                                  and 
                                                                 day_name like 'Sunday'
                                                              ) * interval '1 day' 
                                                            ) and (rp_co_faktur.qtydipesan_faktur >= rp_co_faktur.qtydipesan_co) then 1
          else 0 
          end
      else 0
 end as otif,
case when current_date <= (rp_co_faktur.tglbon + coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') +  

                                                            (
                                                              (select count(tanggal) from dim_hol where tanggal between rp_co_faktur.tglbon and rp_co_faktur.tglcor + (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day')
                                                              ) * interval '1 day'
                                                            ) +
                                                            (
                                                              (select count(*) from dim_time 
                                                                 where 
                                                                 (date between rp_co_faktur.tglbon and rp_co_faktur.tglbon + 
                                                                  (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') 
                                                                  ) 
                                                                  and 
                                                                 day_name like 'Sunday'
                                                              ) * interval '1 day' 
                                                            ) then 
     (case when tglbon is null then 'PB' 
           when tglkirim is null and tglbon is not null then 'PK' 
           when tglserah is null and tglkirim is not null and tglbon is not null then 'PS'
           when tglserah is not null then 'C'
      end
      ) 
     when current_date > (rp_co_faktur.tglbon + coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') +  

                                                            (
                                                              (select count(tanggal) from dim_hol where tanggal between rp_co_faktur.tglbon and rp_co_faktur.tglbon + (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day')
                                                              ) * interval '1 day'
                                                            ) +
                                                            (
                                                              (select count(*) from dim_time 
                                                                 where 
                                                                 (date between rp_co_faktur.tglbon and rp_co_faktur.tglbon + 
                                                                  (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') 
                                                                  ) 
                                                                  and 
                                                                 day_name like 'Sunday'
                                                              ) * interval '1 day' 
                                                            ) then 'C'
     else 'C' end as status,
case when rp_co_faktur.tglserah is not null then 
                         case when (
                                    rp_co_faktur.tglserah > (rp_co_faktur.tglbon + coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') +  

                                                            (
                                                              (select count(tanggal) from dim_hol where tanggal between rp_co_faktur.tglbon and rp_co_faktur.tglbon + (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day')
                                                              ) * interval '1 day'
                                                            ) +
                                                            (
                                                              (select count(*) from dim_time 
                                                                 where 
                                                                 (date between rp_co_faktur.tglbon and rp_co_faktur.tglbon + 
                                                                  (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') 
                                                                  ) 
                                                                  and 
                                                                 day_name like 'Sunday'
                                                              ) * interval '1 day' 
                                                            )

                                    ) and (rp_co_faktur.qtydipesan_faktur >= rp_co_faktur.qtydipesan_co) then 1
                              when (rp_co_faktur.tglserah <= (rp_co_faktur.tglbon + coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') +  

                                                            (
                                                              (select count(tanggal) from dim_hol where tanggal between rp_co_faktur.tglbon and rp_co_faktur.tglbon + (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day')
                                                              ) * interval '1 day'
                                                            ) +
                                                            (
                                                              (select count(*) from dim_time 
                                                                 where 
                                                                 (date between rp_co_faktur.tglbon and rp_co_faktur.tglbon + 
                                                                  (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') 
                                                                  ) 
                                                                  and 
                                                                 day_name like 'Sunday'
                                                              ) * interval '1 day' 
                                                            )

                                    ) and (rp_co_faktur.qtydipesan_faktur >= rp_co_faktur.qtydipesan_co) then 0 else 0 end

     when rp_co_faktur.tglserah is null then
     case when current_date > (rp_co_faktur.tglbon + coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') +  

                                                            (
                                                              (select count(tanggal) from dim_hol where tanggal between rp_co_faktur.tglbon and rp_co_faktur.tglbon + (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day')
                                                              ) * interval '1 day'
                                                            ) +
                                                            (
                                                              (select count(*) from dim_time 
                                                                 where 
                                                                 (date between rp_co_faktur.tglbon and rp_co_faktur.tglbon + 
                                                                  (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') 
                                                                  ) 
                                                                  and 
                                                                 day_name like 'Sunday'
                                                              ) * interval '1 day' 
                                                            ) and (rp_co_faktur.qtydipesan_faktur >= rp_co_faktur.qtydipesan_co)
                                then 1
           when current_date <= (rp_co_faktur.tglbon + coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') +  

                                                            (
                                                              (select count(tanggal) from dim_hol where tanggal between rp_co_faktur.tglbon and rp_co_faktur.tglbon + (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day')
                                                              ) * interval '1 day'
                                                            ) +
                                                            (
                                                              (select count(*) from dim_time 
                                                                 where 
                                                                 (date between rp_co_faktur.tglbon and rp_co_faktur.tglbon + 
                                                                  (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') 
                                                                  ) 
                                                                  and 
                                                                 day_name like 'Sunday'
                                                              ) * interval '1 day' 
                                                            ) and (rp_co_faktur.qtydipesan_faktur >= rp_co_faktur.qtydipesan_co)
                                then 0

          else 0 
    end
    else 0
 end as infull,
 case when rp_co_faktur.tglserah is not null then 
               
                         case when (rp_co_faktur.tglserah > (rp_co_faktur.tglbon + coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') +  

                                                            (
                                                              (select count(tanggal) from dim_hol where tanggal between rp_co_faktur.tglbon and rp_co_faktur.tglbon + (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day')
                                                              ) * interval '1 day'
                                                            ) +
                                                            (
                                                              (select count(*) from dim_time 
                                                                 where 
                                                                 (date between rp_co_faktur.tglbon and rp_co_faktur.tglbon + 
                                                                  (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') 
                                                                  ) 
                                                                  and 
                                                                 day_name like 'Sunday'
                                                              ) * interval '1 day' 
                                                            )) and (rp_co_faktur.qtydipesan_faktur < rp_co_faktur.qtydipesan_co) then 1
                              when (rp_co_faktur.tglserah <= (rp_co_faktur.tglbon + coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') +  

                                                            (
                                                              (select count(tanggal) from dim_hol where tanggal between rp_co_faktur.tglbon and rp_co_faktur.tglbon + (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day')
                                                              ) * interval '1 day'
                                                            ) +
                                                            (
                                                              (select count(*) from dim_time 
                                                                 where 
                                                                 (date between rp_co_faktur.tglbon and rp_co_faktur.tglbon + 
                                                                  (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') 
                                                                  ) 
                                                                  and 
                                                                 day_name like 'Sunday'
                                                              ) * interval '1 day' 
                                                            )) and (rp_co_faktur.qtydipesan_faktur > rp_co_faktur.qtydipesan_co) then 0 else 0 end
          

       when rp_co_faktur.tglserah is null then 

          case when current_date > (rp_co_faktur.tglbon + coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') +  

                                                            (
                                                              (select count(tanggal) from dim_hol where tanggal between rp_co_faktur.tglbon and rp_co_faktur.tglbon + (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day')
                                                              ) * interval '1 day'
                                                            ) +
                                                            (
                                                              (select count(*) from dim_time 
                                                                 where 
                                                                 (date between rp_co_faktur.tglbon and rp_co_faktur.tglbon + 
                                                                  (coalesce(rp_pelangga_area.leadtime,1) * interval '1 day') 
                                                                  ) 
                                                                  and 
                                                                 day_name like 'Sunday'
                                                              ) * interval '1 day' 
                                                            ) and (rp_co_faktur.qtydipesan_faktur < rp_co_faktur.qtydipesan_co) then 1
          else 0 
          end
      else 0
 end as failotif

FROM o_sales_order_report_otif of
