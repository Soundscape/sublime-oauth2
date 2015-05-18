(function(){var e,r,t,i,n,d;e=require("sublime-core"),r=require("sublime-data"),d=require("sails-mongo"),n=[new r.Model({identity:"token",connection:"primary",autoPK:!1},{userId:{type:"string",required:!0},clientId:{type:"string",required:!0},value:{type:"string",required:!0}}),new r.Model({identity:"code",connection:"primary"},{userId:{type:"string",required:!0},clientId:{type:"string",required:!0},redirectUri:{type:"string",required:!0},value:{type:"string",required:!0}}),new r.Model({identity:"client",connection:"primary"},{name:{type:"string",unique:!0,required:!0},userId:{type:"string",required:!0},secret:{type:"string",required:!0}}),new r.Model({identity:"user",connection:"primary"},{username:{type:"string",unique:!0,required:!0},password:{type:"string",required:!0},email:{type:"email",required:!0},thumbnail:{type:"string",required:!0},gender:{type:"string",required:!0}})],t={adapters:{"default":d,mongo:d},connections:{primary:{adapter:"mongo",host:"localhost",port:27017,database:"sublime-db"}},defaults:{migrate:"drop"}},i=new r.DataContext(t),i.init(n).then(function(){return i.models.user.create({username:"admin",password:"admin",email:"shaunfarrell@g.harvard.edu",thumbnail:"https://lh3.googleusercontent.com/-i2djnmHtrWw/AAAAAAAAAAI/AAAAAAAAAF8/NGlm7wio9L4/photo.jpg?sz=50",gender:"male"}).exec(function(e,r){return i.models.client.create({userId:r.id,name:"sublime",secret:"keyboard cat"}).exec(function(){})})}),module.exports=i}).call(this);
