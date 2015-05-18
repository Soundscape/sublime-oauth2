(function(){module.exports=function(e){return{get:function(n,r){return e.models.user.findOne().where({username:n.user.username}).exec(function(e,n){return e?r.send(e):r.json(n)})}}}}).call(this);
