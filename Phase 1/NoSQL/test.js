const mongoose = require('mongoose');

mongoose.connect('mongodb://localhost:27017/ADB_Project_DB', {
    maxPoolSize: 50,
    wtimeoutMS: 2500,
    useNewUrlParser: true
}).then(() => {
    console.log('Connected to MongoDB');
}).catch(err => {
    console.log('Error connecting to MongoDB ', err);
})

// const schema = model("Employee").schema
console.log(mongoose.Schema)


