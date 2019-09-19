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
    res.render('users/add');
})


router.post('/add', async(req, res)=>{
    const { user_name, user_nickname, user_password, user_type } = req.body;
    try{
        sql.close();
        let pool = await sql.connect(config); 
        await pool.request().query('insert into users(user_name, user_nickname, password, user_type)VALUES (\''+user_name+'\',\''+user_nickname+'\',\''+user_password+'\',\''+user_type+'\')');
        console.log('Registro exitoso');
    }catch (err) {
        console.log('se ha producido un error interno. '+err);
    }
    res.redirect('/users');
})

router.get('/delete/:id', async(req, res)=>{
    try{
        sql.close();
        let pool = await sql.connect(config); 
        const { id } = req.params; 
        await pool.request().query('DELETE FROM users WHERE user_code = '+id);
        console.log('Eliminacion exitosa');
    }catch (err) {
        console.log('se ha producido un error interno. '+err);
    }
    res.redirect('/users');
})

router.get('/', async(req, res)=>{
    try{
        sql.close();
        let pool = await sql.connect(config);
        let users = await pool.request().query('select * from users');
        let users_list = users.recordset;
        res.render('users/list', { users_list });
    } catch(err){
        console.log('Se ha producido un error! '+err);
    }
})


router.get('/edit/:id', async(req, res)=>{
    try{
        sql.close();
        let pool = await sql.connect(config);
        const { id } = req.params; 
        let result = await pool.request().query('SELECT * FROM users WHERE user_code = '+id);
        let users = result.recordset;
        res.render('users/edit', {user: users[0]});
        console.log({user: users[0]});
    }catch(err){
        console.log('se ha producido un error '+err);
    }
})

router.post('/edit/:id', async(req, res) =>{
    try{
        sql.close();
        const { id } = req.params;
        const { user_name, user_nickname, user_password, user_type } = req.body;
        let pool = await sql.connect(config);
        await pool.request().query('UPDATE users SET user_name = \''+user_name+'\', user_nickname = \''+user_nickname+'\', password = \''+user_password+'\', user_type=\''+user_type+'\' WHERE user_code = '+id);
        res.redirect('/users')
    }catch(err){
        console.log('ha ocurrido un error '+err);
    }
})

module.exports = router;