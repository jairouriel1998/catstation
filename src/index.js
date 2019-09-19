const express = require('express');
const morgan = require('morgan');
const exphbs = require('express-handlebars');
const path = require('path');
const session = require('express-session');


// initializations
const app = express();

// settings
app.set('port', process.env.PORT || 4000 );
app.set('views', path.join(__dirname, 'views'))
app.engine('.hbs', exphbs({
    defaultLayout: 'main',
    layoutsDir: path.join(app.get('views'), 'layouts'),
    partialsDir: path.join(app.get('views'), 'partials'),
    extname: '.hbs',
    helpers: require('./lib/handlebars')
}));
app.set('view engine', '.hbs');

// Middlewares


app.use(morgan('dev'));
app.use(express.urlencoded({extended: false}))
app.use(express.json());

//Global variables
app.use((req, res, next) => {

    next();
})


// Routes
app.use(require('./routes'));
app.use(require('./routes/authentication'));
app.use('/sales', require('./routes/sales'));
app.use('/stations', require('./routes/stations'));
app.use('/users', require('./routes/users'));
app.use('/', require('./routes/authentication'));

// Public 
app.use(express.static(path.join(__dirname, 'public')))


// Starting the server
app.listen(app.get('port'), () =>{
    console.log('Server on port ', app.get('port'));
})