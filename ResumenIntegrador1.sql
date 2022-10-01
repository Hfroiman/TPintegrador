-- Los pedidos que hayan sido finalizados en menor cantidad de días que la demora promedio

    SELECT 
    AVG(pr.DiasConstruccion)
    from Productos pr


     select 
        *,
        DATEDIFF(DAY,pe.FechaSolicitud,pe.FechaFinalizacion) Demora
    from Pedidos pe
    where DATEDIFF(DAY,pe.FechaSolicitud,pe.FechaFinalizacion) > (SELECT AVG(pr.DiasConstruccion) from Productos pr)
    order by Demora asc

-- Los productos cuyo costo sea mayor que el costo del producto de Roble más caro.

SELECT top 1
pr.Costo
from Materiales ma
inner JOIN Materiales_x_Producto mx on ma.ID=mx.IDMaterial
inner join Productos pr on mx.IDProducto=pr.ID
WHERE ma.Nombre='Roble'
order by pr.Precio desc

SELECT
    pr.Descripcion,
    pr.Costo
from Productos pr
where pr.Costo>
                (SELECT top 1
                pr.Costo
                from Materiales ma
                inner JOIN Materiales_x_Producto mx on ma.ID=mx.IDMaterial
                inner join Productos pr on mx.IDProducto=pr.ID
                WHERE ma.Nombre='Roble'
                order by pr.Precio desc)

-- Los clientes que no hayan solicitado ningún producto de material Pino en el año 2022.

SELECT distinct
cl.ID
from Clientes cl
inner JOIN Pedidos pe on cl.ID=pe.IDCliente
inner JOIN Productos pr on pe.IDProducto=pr.ID
inner join Materiales_x_Producto mx on pr.ID=mx.IDProducto
inner join Materiales ma on mx.IDMaterial=ma.ID
where  year(pe.FechaSolicitud) = 2022 and ma.Nombre='Pino'
order by cl.ID asc


SELECT 
    *
from Clientes cl
where cl.ID not in (SELECT distinct
cl.ID
from Clientes cl
inner JOIN Pedidos pe on cl.ID=pe.IDCliente
inner JOIN Productos pr on pe.IDProducto=pr.ID
inner join Materiales_x_Producto mx on pr.ID=mx.IDProducto
inner join Materiales ma on mx.IDMaterial=ma.ID
where  year(pe.FechaSolicitud) = 2022 and ma.Nombre='Pino')






-- Los colaboradores que no hayan realizado ninguna tarea de Lizado en pedidos que se solicitaron en el año 2021.

select
    co.Apellidos,
    co.Nombres
from Colaboradores co
inner join Tareas_x_Pedido tx on co.Legajo=tx.Legajo
inner join Tareas t on tx.IDTarea=t.ID


-- Los clientes a los que les hayan enviado (no necesariamente entregado) al menos un tercio de sus pedidos.

SELECT
    cl.Apellidos,
    cl.Nombres,
    (
        select COUNT(*) from Pedidos pe where pe.IDCliente=cl.ID
    ) cantPedidos,
    (
        select COUNT(*) from Pedidos pe 
        INNER join Envios en on pe.ID=en.IDPedido
        where pe.IDCliente=cl.ID
    ) CantEnviados
FROM Clientes cl
where (select COUNT(*) from Pedidos pe where pe.IDCliente=cl.ID)<= (select COUNT(*) from Pedidos pe 
        INNER join Envios en on pe.ID=en.IDPedido
        where pe.IDCliente=cl.ID)*3


-- Los colaboradores que hayan realizado todas las tareas (no necesariamente en un mismo pedido).
-- Por cada producto, la descripción y la cantidad de colaboradores fulltime que hayan trabajado en él y la cantidad de colaboradores parttime.

SELECT COUNT(*) TrabajadoreFull from Colaboradores col
        inner join Tareas_x_Pedido tx on tx.Legajo=col.Legajo
        inner join Pedidos pe on pe.ID=tx.IDPedido
        inner join Productos pr  on pr.ID=pe.IDProducto
where col.ModalidadTrabajo='F'


SELECT
     pr.Descripcion,
    (
        SELECT COUNT(*) TrabajadoreFull from Colaboradores col
            inner join Tareas_x_Pedido tx on tx.Legajo=col.Legajo
            inner join Pedidos pe on pe.ID=tx.IDPedido
            where  pr.ID=pe.IDProducto and col.ModalidadTrabajo='F'
    ) as TrabajadoresFulltime,
    (
        SELECT COUNT(*) TrabajadoreFull from Colaboradores col
            inner join Tareas_x_Pedido tx on tx.Legajo=col.Legajo
            inner join Pedidos pe on pe.ID=tx.IDPedido
            where  pr.ID=pe.IDProducto and col.ModalidadTrabajo='P'
    ) as TrabajadoresPartime
FROM Productos pr





-- Por cada producto, la descripción y la cantidad de pedidos enviados y la cantidad de pedidos sin envío.

SELECT
    pr.Descripcion,
    (
        select COUNT(pe.ID) from Envios e
            inner JOIN Pedidos pe on e.IDPedido=pe.ID
            where pe.IDProducto=pr.ID
    )CantEnviados,
    (
    /*CALCULAR LOS QUE NO FUERON ENVIADOS*/
    )CantNOEnviados
from Productos pr

select COUNT(pe.ID) from Envios e
inner JOIN Pedidos pe on e.IDPedido=pe.ID
inner join Productos pr on pe.IDProducto=pr.ID


-- Por cada cliente, apellidos y nombres y la cantidad de pedidos solicitados en los años 2020, 2021 y 2022. (Cada año debe mostrarse en una columna separada)
-- Por cada producto, listar la descripción del producto, el costo y los materiales de construcción (en una celda separados por coma)
-- Por cada pedido, listar el ID, la fecha de solicitud, el nombre del producto, los apellidos y nombres de los colaboradores que trabajaron en el pedido y la/s tareas que el colaborador haya realizado (en una celda separados por coma)
-- Las descripciones de los productos que hayan requerido el doble de colaboradores fulltime que colaboradores partime.
-- Las descripciones de los productos que tuvieron más pedidos sin envíos que con envíos pero que al menos tuvieron un pedido enviado.
-- Los nombre y apellidos de los clientes que hayan realizado pedidos en los años 2020, 2021 y 2022 pero que la cantidad de pedidos haya decrecido en cada año. Añadirle al listado aquellos clientes que hayan realizado exactamente la misma cantidad de pedidos en todos los años y que dicha cantidad no sea cero.

