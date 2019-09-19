const express = require('express');
const router = express.Router();

//const pool = require('../database');
const sql = require('mssql');

const config = {
    user: 'sa',
    password: 'Jairo1998',
    server: 'localhost',
    database: 'catstation_database'
}

router.get('/add', (req, res)=>{
    res.render('sales/add');
})

router.post('/add', async(req, res) =>{
    const {sale_liters_sold, emp_sale_code, dispenser_sale_code } = req.body;
    try{
        sql.close();
        let pool = await sql.connect(config); 
        await pool.request().query('insert into sales(sale_liters_sold, emp_sale_code, dispenser_sale_code) VALUES ('+sale_liters_sold+','+emp_sale_code+','+dispenser_sale_code+')');
        console.log('Registro exitoso');
    }catch (err) {
        console.log('se ha producido un error interno. '+err);
    }
    res.redirect('/sales');
})

router.get('/', async(req, res)=>{
    try{
        sql.close();
        let pool = await sql.connect(config);
        let sales = await pool.request().query('select * from viewSales');
        let sales_list = sales.recordset;
        res.render('sales/list', { sales_list });
    } catch(err){
        console.log('Se ha producido un error! '+err);
    }
    
})

router.get('/delete/:id', async(req, res)=>{
    try{
        sql.close();
        let pool = await sql.connect(config);
        const { id } = req.params; 
        await pool.request().query('DELETE FROM sales WHERE sale_code = '+id);
        res.redirect('/sales');
    }catch(err){
        console.log('se ha producido un error '+err);
    }
})

router.get('/edit/:id', async(req, res)=>{
    try{
        sql.close();
        let pool = await sql.connect(config);
        const { id } = req.params; 
        let result = await pool.request().query('SELECT * FROM sales WHERE sale_code = '+id);
        let sales = result.recordset;
        console.log(sales);
        res.render('sales/edit', {sale: sales[0]});
    }catch(err){
        console.log('se ha producido un error '+err);
    }
})

router.post('/edit/:id', async(req, res) =>{
    try{
        const { id } = req.params;
        const {sale_liters_sold, emp_sale_code, dispenser_sale_code } = req.body;
        let pool = await sql.connect(config);
        await pool.request().query('UPDATE sales SET sale_liters_sold='+sale_liters_sold+', emp_sale_code='+emp_sale_code+', dispenser_sale_code='+dispenser_sale_code+' WHERE sale_code = '+id);
        res.redirect('/sales')
    }catch(err){
        console.log('ha ocurrido un error '+err);
    }
})

module.exports = router;