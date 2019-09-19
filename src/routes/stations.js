const express = require('express');
const router = express.Router();

const sql = require('mssql');

const config = {
    user: 'sa',
    password: 'Jairo1998',
    server: 'localhost',
    database: 'catstation_database'
}

router.get('/add', (req, res)=>{
    res.render('stations/add');
})

router.post('/add', async(req, res)=>{
    const { station_idname, station_startdate, station_address, station_operationlog, station_city, station_department } = req.body;
    try{
        sql.close();
        let pool = await sql.connect(config); 
        await pool.request().query('insert into service_station(station_idname, station_startdate, station_address, station_operationlog, station_city, station_department) VALUES (\''+station_idname+'\',\''+station_startdate+'\',\''+station_address+'\',\''+station_operationlog+'\',\''+station_city+'\',\''+station_department+'\')');
        console.log('Registro exitoso');
    }catch (err) {
        console.log('se ha producido un error interno. '+err);
    }
    res.redirect('/stations');
})

router.get('/delete/:id', async(req, res)=>{
    try{
        sql.close();
        let pool = await sql.connect(config); 
        const { id } = req.params; 
        await pool.request().query('DELETE FROM service_station WHERE station_code = '+id);
        console.log('Eliminacion exitosa');
    }catch (err) {
        console.log('se ha producido un error interno. '+err);
    }
    res.redirect('/stations');
})

router.get('/', async(req, res)=>{
    try{
        sql.close();
        let pool = await sql.connect(config);
        let stations = await pool.request().query('select * from viewServiceStations');
        let stations_list = stations.recordset;
        res.render('stations/list', { stations_list });
    } catch(err){
        console.log('Se ha producido un error! '+err);
    }
})


router.get('/edit/:id', async(req, res)=>{
    try{
        sql.close();
        let pool = await sql.connect(config);
        const { id } = req.params; 
        let result = await pool.request().query('SELECT * FROM viewServiceStations WHERE station_code = '+id);
        let stations = result.recordset;
        res.render('stations/edit', {station: stations[0]});
        console.log({station: stations[0]});
    }catch(err){
        console.log('se ha producido un error '+err);
    }
})

router.post('/edit/:id', async(req, res) =>{
    try{
        sql.close();
        const { id } = req.params;
        const { station_idname, station_startdate, station_address, station_operationlog, station_city, station_department } = req.body;
        let pool = await sql.connect(config);
        await pool.request().query('UPDATE service_station SET station_idname=\''+station_idname+'\', station_startdate=\''+station_startdate+'\', station_address=\''+station_address+'\', station_operationlog=\''+station_operationlog+'\', station_city=\''+station_city+'\', station_department=\''+station_department+'\' WHERE station_code = '+id);
        res.redirect('/stations')
    }catch(err){
        console.log('ha ocurrido un error '+err);
    }
})

module.exports = router;