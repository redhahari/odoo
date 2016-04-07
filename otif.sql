SELECT 
        so.name as noso,
        date_order,
        split_part(dc.name,' ',2) as dc,
        cus.name as customer,
		cus.id   as customer_id,
        cus.street as street,
        cus.district as kecamatan,
        cus.sub_district as kelurahan,
        dch.name as channel,
        oo.name as kode_tipe_outlet,
        oc.name as jenis_outlet,
        aa.name as area,
        pc.name as cara_bayar,
        s.name as salesname,
        om.name as order_method,
        war.name as warehouse,
        split_part(pb.name,':',2) as brand,
        pt.old_koitem as coitem,
        concat('[',sol.product_id,'] ',pt.name) as product,
        sol.product_id as product_id,
        sol.product_uom_qty as ordered_quantity,
        sol.qty_delivered as delivered_quantity,
        sol.qty_invoiced as invoiced_quantity,
        sol.customer_lead as delivery_lead_time,
        sol.price_unit as unit_price,
        sol.price_after_discounts as price_after_discounts,
        sol.price_subtotal as price_subtotal,
        sol.invoice_status as invoice_status,
        sol.qty_to_invoice as qty_to_invoice,
        sol.qty_returned as qty_returned,
        sol.state as state
FROM 
sale_order so
left join res_partner dc on so.dc_id = dc.id
left join res_partner cus on so.partner_id = cus.id
left join payment_category pc on cus.payment_category = pc.id
left join distribution_channel dch on dch.id = cus.distribution_channel
left join outlet_outlet oo on oo.id = cus.outlet_type
left join outlet_category oc on oc.id = cus.outlet_category
left join area_area aa on aa.id = cus.area
left join res_partner s on so.sales_id = s.id
left join stock_warehouse war on so.warehouse_id = war.id
left join order_method om on so.order_method = om.id
left join sale_order_line sol on so.id = sol.order_id
left join product_template pt on sol.product_id = pt.id
left join product_brand_product_template_rel pbpt on pt.id = pbpt.product_template_id
left join product_brand pb on pbpt.product_brand_id = pb.id
