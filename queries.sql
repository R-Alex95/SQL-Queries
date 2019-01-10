1)
select p.number
from airplanes as p,airlines as a,airlines_has_airplanes as k
where p.manufacturer = 'Boeing' and a.name = 'British Airways' and k.airplanes_id = p.id and k.airlines_id = a.id

2)
select a.name
from airlines as a,routes as r,airports as p1,airports as p2
where p1.city = 'Athens' and  p1.id = r.source_id and p2.city = 'London' and p2.id = r.destination_id and a.id = r.airlines_id

3)
select count(*) as 'number'
from passengers as p,flights as f,flights_has_passengers as k,airlines as a,routes as r
where f.date = '2012-02-19' and k.flights_id = f.id and k.passengers_id = p.id and a.name = 'Aegean Airlines' and f.routes_id = r.id and r.airlines_id = a.id

4)
select 'yes' as result
from flights as f
where exists (select * 
			  from airlines as a,routes as r,airports as p1,airports as p2
			  where a.name = 'Olympic Airways' and p1.name = 'Athens El. Venizelos' and p1.id = r.source_id and p2.name = 'London Gatwick' and p2.id = r.destination_id and f.date = '2014-12-12' and f.routes_id = r.id)
union 
select 'no' as result
from flights as f
where not exists (select *
				  from airlines as a
          where not exists (select *
            from routes as r,airports as p1 ,airports as p2
            where a.id =  r.airlines_id and a.name = 'Olympic Airways' and p1.name = 'Athens El. Venizelos' and p1.id = r.source_id
            and p2.name = 'London Gatwick' and p2.id = r.destination_id and f.date = '2014-12-12' and r.id = f.routes_id)
                   )

5)
select avg(distinct 2015-year_of_birth) as age
from passengers as p , routes as r , flights as f ,flights_has_passengers as k , airports as a 
where k.flights_id = f.id and k.passengers_id = p.id and f.routes_id = r.id and r.destination_id = a.id and a.city = 'Athens'

6)
select distinct p.name,p.surname
from passengers as p,flights as f ,flights_has_passengers as k
where k.passengers_id=p.id and k.flights_id = f.id 
      and f.airplanes_id = all(select f1.airplanes_id
															from flights f1, flights_has_passengers k1
                              where k1.passengers_id = p.id and k1.flights_id = f1.id)

7)
select a1.city as 'from' , a2.city as 'to'
from airports as a1,airports as a2,routes as r,passengers as p,flights as f,flights_has_passengers as k
where f.date between '2011-02-01' and '2014-07-17' and f.routes_id = r.id and r.source_id = a1.id and r.destination_id = a2.id		
	  and k.flights_id = f.id and k.passengers_id = p.id
group by f.id
having count(*) > 5



8)
select a.name as 'name',a.code as 'code',count(distinct r.id)
from airlines as a,airplanes as p,airlines_has_airplanes as k,routes as r
where a.id = k.airlines_id and p.id = k.airplanes_id and r.airlines_id = a.id
group by a.id
having count(*) = 5 

9)
select p.name ,p.surname
from passengers as p
where not exists (select *
				  from airlines as a
          where a.active = 'Y'
          and not exists (select *
													from routes as r,flights_has_passengers as k,flights as f
													where r.airlines_id = a.id and f.id = k.flights_id and p.id = k.passengers_id and f.routes_id = r.id)
                )

10)
select distinct p.name ,p.surname
from passengers as p
where not exists (select * from airlines as a
				  where a.name = 'British Airways' 
          and not exists (select *
													from flights as f,flights_has_passengers as k,routes as r
													where p.id = k.passengers_id and f.id = k.flights_id and r.id = f.routes_id and r.airlines_id = a.id))
union
select distinct p.name ,p.surname
from passengers as p,flights as f,flights_has_passengers as k
where p.id = k.passengers_id and f.id = k.flights_id and f.date between '2010-01-01' and '2013-12-31'
group by p.id
having count(*) > 1