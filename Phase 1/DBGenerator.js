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

const EmployeeSchema = new mongoose.Schema({
    Fname: String,
    Lname: String,
    Minit: String,
    Ssn: Number,
    Bdate: Date,
    Sex: String,
    Salary: Number,
    Super_ssn: Number,
    Dno: Number
});

const DepartmentSchema = new mongoose.Schema({
    Dname: String,
    Dnumber: Number,
});

const ProjectSchema = new mongoose.Schema({
    Pname: String,
    Pnumber: Number,
    Plocation: String,
    Dnum: Number
});

const Works_OnSchema = new mongoose.Schema({
    Essn: Number,
    Pno: Number,
    Hours: Number
});

const DependentSchema = new mongoose.Schema({
    Essn: Number,
    Dependent_name: String,
    Sex: String,
    Bdate: Date,
    Relationship: String
});

EmployeeSchema.virtual('department', {
    ref: 'Department',
    localField: 'Dno',
    foreignField: 'Dnumber',
    justOne: true
});

EmployeeSchema.virtual('works_on', {
    ref: 'Works_On',
    localField: 'Ssn',
    foreignField: 'Essn',
    justOne: true
});

EmployeeSchema.virtual('dependent', {
    ref: 'Dependent',
    localField: 'Ssn',
    foreignField: 'Essn',
    justOne: true
});

ProjectSchema.virtual('works_on', {
    ref: 'Works_On',
    localField: 'Pnumber',
    foreignField: 'Pno',
    justOne: true
});

DepartmentSchema.virtual('employee', {
    ref: 'Employee',
    localField: 'Dnumber',
    foreignField: 'Dno',
    justOne: true
});

DepartmentSchema.virtual('project', {
    ref: 'Project',
    localField: 'Dnumber',
    foreignField: 'Dnum',
    justOne: true
});

Works_OnSchema.virtual('employee', {
    ref: 'Employee',
    localField: 'Essn',
    foreignField: 'Ssn',
    justOne: true
});

Works_OnSchema.virtual('project', {
    ref: 'Project',
    localField: 'Pno',
    foreignField: 'Pnumber',
    justOne: true
});

DependentSchema.virtual('employee', {
    ref: 'Employee',
    localField: 'Essn',
    foreignField: 'Ssn',
    justOne: true
});

const Employee = mongoose.model('Employee', EmployeeSchema);

const Department = mongoose.model('Department', DepartmentSchema);

const Project = mongoose.model('Project', ProjectSchema);

const Works_On = mongoose.model('Works_On', Works_OnSchema);

const Dependent = mongoose.model('Dependent', DependentSchema);