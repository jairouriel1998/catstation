const sql = require('mssql');
const { promisify } = require('util');

const { database } = require('./keys');

const pool = new sql.ConnectionPool(database);

pool.connect((err, connection) =>{
    if(err){
        if(err.code === 'PROTOCOL_CONNETION_LOST'){
            console.error('Database connection was closed');
        }
        if(err.code === 'ER__CON_COUNT_ERROR'){
            console.error('Database has to many connections');
        }
        if(err.code === 'ECONNREFUSED'){
            console.error('Database connection was refused');
        }
    }
    if(connection) connection.release();
    console.log('DB is connected');
    return;
});

// Promisify pool querys
pool.query = promisify(pool.query);

module.exports = pool;