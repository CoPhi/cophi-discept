function DomVisitor(){}

DomVisitor.prototype.visitChildren=function(ctx){
    if(!ctx){
	return;
    }
    var node;
    node="<"+DomVisitor.prototype.getName(ctx)+">";
    if(ctx.children){
	for(var i=0;i<ctx.children.length;i++){
	    node+=ctx.children[i].accept(this);
	}
	return node+="</"+DomVisitor.prototype.getName(ctx)+">";
    }
    return;
}

DomVisitor.prototype.visitTerminal=function(ctx){
    return ctx.getText()+" ";
}

DomVisitor.prototype.getName=function(ctx){
    var name=ctx.constructor.name;
    name=name.substring(0,1).toLowerCase()+name.substring(1);
    return name.replace(/Context$/g,'');
}

exports.DomVisitor=DomVisitor;
